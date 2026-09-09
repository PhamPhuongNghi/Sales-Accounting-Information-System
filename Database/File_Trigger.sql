
--Nếu NamTK là năm hiện tại, thì ThangTK  phải nhỏ hơn hoặc bằng tháng hiện tại.
CREATE TRIGGER trg_TonKho_CheckThangHienTai
ON TonKho_CuaHang
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentYear INT = YEAR(GETDATE());
    DECLARE @CurrentMonth INT = MONTH(GETDATE());

    -- Tìm kiếm các bản ghi vi phạm trong tập hợp dữ liệu được chèn/cập nhật (INSERTED)
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        -- Điều kiện vi phạm: Năm tồn kho = Năm hiện tại VÀ Tháng tồn kho > Tháng hiện tại
        WHERE NamTK = @CurrentYear AND ThangTK > @CurrentMonth
    )
    BEGIN
        -- Báo lỗi cho người dùng
        RAISERROR ('Lỗi nghiệp vụ: Không được tạo/cập nhật tồn kho cho tháng tương lai trong năm hiện tại.', 16, 1)
        -- Hủy bỏ toàn bộ giao dịch
        ROLLBACK TRANSACTION
        RETURN 
    END
END;

--Một phiếu xuất chỉ được xuất các sản phẩm đang còn tồn kho.
CREATE TRIGGER trg_CheckTonKho_CTPX
ON CTPX
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra tất cả các dòng được chèn hoặc cập nhật
    IF EXISTS (
        SELECT 
            1
        FROM 
            INSERTED i
        INNER JOIN 
            PhieuXuat px ON i.SoPX = px.SoPX
        LEFT JOIN (
            -- Subquery này tìm TonCK gần nhất cho từng cặp (MaCH, MaSP)
            SELECT
                tk.MaCH,
                tk.MaSP,
                tk.TonCK,
                -- Xếp hạng bản ghi tồn kho theo thời gian (năm giảm, tháng giảm)
                ROW_NUMBER() OVER (PARTITION BY tk.MaCH, tk.MaSP ORDER BY tk.NamTK DESC, tk.ThangTK DESC) AS rn
            FROM 
                TonKho_CuaHang tk
        ) AS LatestTonKho ON LatestTonKho.MaCH = px.MaCH 
                          AND LatestTonKho.MaSP = i.MaSP
                          AND LatestTonKho.rn = 1 -- Chỉ lấy bản ghi tồn kho mới nhất
        WHERE 
            -- Điều kiện vi phạm: Số lượng xuất lớn hơn Tồn Cuối Kỳ
            i.SoLuongPX > ISNULL(LatestTonKho.TonCK, 0) 
            -- ISNULL(LatestTonKho.TonCK, 0) đảm bảo nếu không tìm thấy tồn kho, 
            -- nó coi như tồn kho là 0 và báo lỗi nếu SLuongPX > 0.
    )
    BEGIN
        -- Báo lỗi và hủy bỏ toàn bộ giao dịch (INSERT/UPDATE)
        RAISERROR ('Lỗi nghiệp vụ: Số lượng xuất vượt quá tồn kho cuối kỳ (TonCK) gần nhất của sản phẩm tại cửa hàng.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN 
    END
END;

--Trị giá hóa đơn phải bằng thành tiền trong chi tiết hóa đơn 
CREATE TRIGGER TR_TongTien_HoaDon
ON CTHD
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- 1. Khai báo bảng tạm chứa danh sách các SoHD bị ảnh hưởng
    DECLARE @Affected_HD TABLE (SoHD VARCHAR(20));

    -- Thêm các SoHD từ dữ liệu mới (INSERTED) và cũ (DELETED) vào bảng tạm
    INSERT INTO @Affected_HD (SoHD)
    SELECT SoHD FROM INSERTED
    UNION
    SELECT SoHD FROM DELETED;

    -- 2. Cập nhật lại TriGiaHD trong bảng HoaDon cho các hóa đơn bị ảnh hưởng
    UPDATE h
    SET TriGiaHD = ISNULL(t.TongTien, 0)
    FROM HoaDon AS h
    INNER JOIN (
        SELECT SoHD, SUM(SoLuongHD * DonGiaHD) AS TongTien
        FROM CTHD
        WHERE SoHD IN (SELECT SoHD FROM @Affected_HD)
        GROUP BY SoHD
    ) AS t ON h.SoHD = t.SoHD
    WHERE h.SoHD IN (SELECT SoHD FROM @Affected_HD);
END;

--Trị giá phiếu nhập phải bằng tổng tiền trong chi tiết phiếu nhập
CREATE TRIGGER TR_TongTien_PhieuNhap
ON CTPN 
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- 1. Khai báo bảng tạm chứa danh sách các SoPN bị ảnh hưởng
    DECLARE @Affected_PN TABLE (SoPN VARCHAR(20));

    -- Thêm các SoPN từ dữ liệu mới (INSERTED) và cũ (DELETED) vào bảng tạm
    INSERT INTO @Affected_PN (SoPN)
    SELECT SoPN FROM INSERTED
    UNION
    SELECT SoPN FROM DELETED;

    -- 2. Cập nhật lại TriGiaNhap trong bảng PhieuNhap cho các phiếu nhập bị ảnh hưởng
    UPDATE pn
    SET TriGiaNhap = ISNULL(t.TongTien, 0)
    FROM PhieuNhap AS pn
    INNER JOIN (
        SELECT 
            ct.SoPN, 
            SUM(ct.SoLuongPN * sp.GiaNhap) AS TongTien -- Tính tổng tiền: Số lượng nhập * Giá nhập
        FROM CTPN AS ct
        INNER JOIN SanPham AS sp ON ct.MaSP = sp.MaSP -- Lấy GiaNhap từ bảng SanPham
        WHERE ct.SoPN IN (SELECT SoPN FROM @Affected_PN)
        GROUP BY ct.SoPN
    ) AS t ON pn.SoPN = t.SoPN
    WHERE pn.SoPN IN (SELECT SoPN FROM @Affected_PN);
END;

--Trị giá phiếu xuất phải bằng tổng tiền trong chi tiết phiếu xuất
CREATE TRIGGER TR_TongTien_PhieuXuat
ON CTPX
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- 1. Khai báo bảng tạm chứa danh sách các SoPX bị ảnh hưởng
    DECLARE @Affected_PX TABLE (SoPX VARCHAR(20));

    -- Thêm các SoPX từ dữ liệu mới (INSERTED) và cũ (DELETED) vào bảng tạm
    INSERT INTO @Affected_PX (SoPX)
    SELECT SoPX FROM INSERTED
    UNION
    SELECT SoPX FROM DELETED;

    -- 2. Cập nhật lại TriGiaXuat trong bảng PhieuXuat cho các phiếu xuất bị ảnh hưởng
    UPDATE px
    SET TriGiaXuat = ISNULL(t.TongTien, 0)
    FROM PhieuXuat AS px
    INNER JOIN (
        SELECT 
            SoPX, 
            SUM(SoLuongPX * DonGiaPX) AS TongTien -- Tính tổng tiền: Số lượng xuất * Đơn giá xuất
        FROM CTPX
        WHERE SoPX IN (SELECT SoPX FROM @Affected_PX)
        GROUP BY SoPX
    ) AS t ON px.SoPX = t.SoPX
    WHERE px.SoPX IN (SELECT SoPX FROM @Affected_PX);
END;

--Ngày Lập Hóa Đơn phải xảy ra sau hoặc bằng Ngày Xuất Hàng.
CREATE TRIGGER trg_CheckNgayLapHD_NgayXuat
ON HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra xem có dòng nào vi phạm điều kiện không
    IF EXISTS (
        SELECT 
            1
        FROM 
            INSERTED i
        INNER JOIN 
            PhieuXuat px ON i.SoHD = px.SoHD
        WHERE 
            -- Điều kiện vi phạm: Ngày Lập Hóa Đơn (i.NgayLap) NHỎ HƠN Ngày Xuất Hàng (px.NgayXuat)
            i.NgayLapHD < px.NgayXuat
    )
    BEGIN
        -- Báo lỗi và hủy bỏ toàn bộ giao dịch
        RAISERROR ('Lỗi nghiệp vụ: Ngày Lập Hóa Đơn phải xảy ra sau hoặc bằng Ngày Xuất Hàng.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN 
    END
END;

--Ngày Nhập Kho của một sản phẩm phải sau hoặc bằng Ngày Ra Mắt của sản phẩm đó
CREATE TRIGGER TR_NgayNhap_Sau_NgayRaMat
ON CTPN
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra điều kiện
    IF EXISTS (
        SELECT 1
        FROM INSERTED AS i
        INNER JOIN SanPham AS sp ON i.MaSP = sp.MaSP
        INNER JOIN PhieuNhap AS pn ON i.SoPN = pn.SoPN
        WHERE pn.NgayNhap < sp.NgayRaMat
    )
    BEGIN
        -- Báo lỗi và hủy bỏ thao tác
        RAISERROR (N'Lỗi: Ngày Nhập Kho phải sau hoặc bằng Ngày Ra Mắt của sản phẩm.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;

--Đơn Giá Hóa Đơn nhỏ hơn hoặc bằng Giá Bán Dự Kiến của sản phẩm đó.
CREATE TRIGGER TR_GiaBan_KhongVuotDuKien
ON CTHD
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra điều kiện: Đơn giá hóa đơn (i.DonGia) > Giá bán dự kiến (sp.GiaBanDuKien)
    IF EXISTS (
        SELECT 1
        FROM INSERTED AS i
        INNER JOIN SanPham AS sp ON i.MaSP = sp.MaSP
        WHERE i.DonGiaHD > sp.GiaBanDuKien
    )
    BEGIN
        -- Báo lỗi và hủy bỏ thao tác
        RAISERROR (N'Lỗi: Đơn Giá Hóa Đơn không được lớn hơn Giá Bán Dự Kiến của sản phẩm.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;

--Đơn Giá Nhập Kho phải nhỏ hơn hoặc bằng Giá Bán Dự Kiến
CREATE TRIGGER TR_GiaNhap_KhongVuotGiaBan
ON SanPham
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra điều kiện vi phạm: GiaNhap (i.GiaNhap) > GiaBanDuKien (i.GiaBanDuKien)
    IF EXISTS (
        SELECT 1
        FROM INSERTED AS i
        WHERE i.GiaNhap > i.GiaBanDuKien
    )
    BEGIN
        -- Báo lỗi và hủy bỏ thao tác
        RAISERROR (N'Lỗi: Đơn Giá Nhập Kho không được lớn hơn Giá Bán Dự Kiến.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;


