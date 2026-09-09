create database LnL_HTTTKT
CREATE TABLE SanPham (
    MaSP VARCHAR(20) PRIMARY KEY,
    TenSP NVARCHAR(255) NOT NULL,
    MoTa NVARCHAR(255) NULL,
    DVT VARCHAR(50) NULL,
    NgayRaMat DATE NULL,
    GiaNhap FLOAT NULL,
    GiaBanDuKien FLOAT NULL,
    DienAp VARCHAR(50) NULL,
    KichThuoc VARCHAR(50) NULL,
    TrongLuong VARCHAR(50) NULL,
    CongSuat VARCHAR(50) NULL,
    DungTich VARCHAR(50) NULL,
    Hinh VARCHAR(255) NULL,
    MaLoaiSP VARCHAR(20) NULL,
    MaMauSac VARCHAR(20) NULL,
    CONSTRAINT FK_SanPham_LoaiSP FOREIGN KEY (MaLoaiSP)
        REFERENCES LoaiSP(MaLoaiSP),
    CONSTRAINT FK_SanPham_MauSac FOREIGN KEY (MaMauSac)
        REFERENCES MauSac(MaMauSac)
);
CREATE TABLE LoaiSP (
    MaLoaiSP VARCHAR(20) PRIMARY KEY,
    TenLoaiSP NVARCHAR(255) NOT NULL
);
CREATE TABLE MauSac (
    MaMauSac VARCHAR(20) PRIMARY KEY,
    TenMauSac NVARCHAR(255) NOT NULL
);
CREATE TABLE CuaHang (
    MaCH VARCHAR(20) PRIMARY KEY,
    TenCH NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255) NULL,
    SDT VARCHAR(20) NULL
);
CREATE TABLE BoPhan (
    MaBP VARCHAR(20) PRIMARY KEY,
    MaCH VARCHAR(20) NOT NULL,
    TenBP NVARCHAR(255) NOT NULL,
    SDT_BP VARCHAR(20) NULL,
    Email_BP VARCHAR(255) NULL,
    CONSTRAINT FK_BoPhan_CuaHang FOREIGN KEY (MaCH)
        REFERENCES CuaHang(MaCH)
);
CREATE TABLE TonKho_CuaHang (
    MaCH VARCHAR(20) NOT NULL,
    MaSP VARCHAR(20) NOT NULL,
    ThangTK INT NOT NULL,
    NamTK INT NOT NULL,
    TonDK INT NULL,
    TriGiaTonDK FLOAT NULL,
    NhapTK INT NULL,
    TriGiaNhapTK FLOAT NULL,
    XuatTK INT NULL,
    TriGiaXuatTK FLOAT NULL,
    TonCK INT NULL,
    TriGiaTonCK FLOAT NULL,
    CONSTRAINT PK_TonKho PRIMARY KEY (MaCH, MaSP, ThangTK, NamTK),
    CONSTRAINT FK_TonKho_CuaHang FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    CONSTRAINT FK_TonKho_SanPham FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
CREATE TABLE KhachHang (
    MaKH VARCHAR(20) PRIMARY KEY,
    TenKH NVARCHAR(255) NOT NULL,
    SDT_KH VARCHAR(20) NULL,
    Email_KH VARCHAR(50) NULL,
    NgaySinh_KH DATE NULL
);
CREATE TABLE TaiKhoan (
    MaTaiKhoan VARCHAR(20) PRIMARY KEY,
    TenTaiKhoan NVARCHAR(255) NOT NULL
);
CREATE TABLE TieuKhoan (
    MaTieuKhoan VARCHAR(20) PRIMARY KEY,
    MaTaiKhoan VARCHAR(20) NOT NULL,
    TenTieuKhoan NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_TieuKhoan_TaiKhoan FOREIGN KEY (MaTaiKhoan)
        REFERENCES TaiKhoan(MaTaiKhoan)
);
CREATE TABLE TietKhoan (
    MaTietKhoan VARCHAR(20) PRIMARY KEY,
    MaTieuKhoan VARCHAR(20) NOT NULL,
    TenTietKhoan NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_TietKhoan_TieuKhoan FOREIGN KEY (MaTieuKhoan)
        REFERENCES TieuKhoan(MaTieuKhoan)
);
CREATE TABLE SoDuDK (
    MaTietKhoan VARCHAR(20) NOT NULL,
    ThangDK INT NOT NULL,
    NamDK INT NOT NULL,
    SoTienDK FLOAT NULL,
    DuNo VARCHAR(50) NULL,
    CONSTRAINT PK_SoDuDauKy PRIMARY KEY (MaTietKhoan, ThangDK, NamDK),
    CONSTRAINT FK_SoDuDauKy_TietKhoan FOREIGN KEY (MaTietKhoan)
        REFERENCES TietKhoan(MaTietKhoan)
);
CREATE TABLE PhieuNhap (
    SoPN VARCHAR(20) PRIMARY KEY,
    MaCH VARCHAR(20) NOT NULL,
    NgayNhap DATE NOT NULL,
    TriGiaNhap FLOAT NULL,
    MaNV VARCHAR(20) NULL,
    CONSTRAINT FK_PhieuNhap_CuaHang FOREIGN KEY (MaCH)
        REFERENCES CuaHang(MaCH),
    CONSTRAINT FK_PhieuNhap_NhanVien FOREIGN KEY (MaNV)
        REFERENCES NhanVien(MaNV)
);
CREATE TABLE CTPN (
    SoPN VARCHAR(20) NOT NULL,
    MaSP VARCHAR(20) NOT NULL,
    SoLuongPN INT NULL,
    DonGiaPN FLOAT NULL,
    TTienPN FLOAT NULL,
    CONSTRAINT PK_ChiTietPhieuNhap PRIMARY KEY (SoPN, MaSP),
    CONSTRAINT FK_CTPN_PhieuNhap FOREIGN KEY (SoPN)
        REFERENCES PhieuNhap(SoPN),
    CONSTRAINT FK_CTPN_SanPham FOREIGN KEY (MaSP)
        REFERENCES SanPham(MaSP)
);
CREATE TABLE TaiKhoanNguoiDung (
    MaTKND VARCHAR(20) PRIMARY KEY,
    TenTKND NVARCHAR(255) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    Quyen NVARCHAR(255) NULL
);
CREATE TABLE NhanVien (
    MaNV VARCHAR(20) PRIMARY KEY,
    MaBP VARCHAR(20) NOT NULL,
    MaTKND VARCHAR(20) NULL,
    TenNV NVARCHAR(255) NOT NULL,
    SDT_NV VARCHAR(20) NULL,
    Email_NV VARCHAR(50) NULL,
    CONSTRAINT FK_NhanVien_BoPhan FOREIGN KEY (MaBP)
        REFERENCES BoPhan(MaBP),
    CONSTRAINT FK_NhanVien_TaiKhoan FOREIGN KEY (MaTKND)
        REFERENCES TaiKhoanNguoiDung(MaTKND)
);
CREATE TABLE HoaDon (
    SoHD VARCHAR(20) PRIMARY KEY,
    MaNV VARCHAR(20) NOT NULL,
    MaKH VARCHAR(20) NULL,
    NgayLapHD DATE NOT NULL,
    TriGiaHD FLOAT NULL,
    VAT FLOAT NULL,
    TongTienHD FLOAT NULL,
    CONSTRAINT FK_HoaDon_NhanVien FOREIGN KEY (MaNV)
        REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_HoaDon_KhachHang FOREIGN KEY (MaKH)
        REFERENCES KhachHang(MaKH)
);
CREATE TABLE CTHD (
    SoHD VARCHAR(20) NOT NULL,
    MaSP VARCHAR(20) NOT NULL,
    SoLuongHD INT NULL,
    DonGiaHD FLOAT NULL,
    TTienHD FLOAT NULL,
    CONSTRAINT PK_ChiTietHoaDon PRIMARY KEY (SoHD, MaSP),
    CONSTRAINT FK_CTHD_HoaDon FOREIGN KEY (SoHD)
        REFERENCES HoaDon(SoHD),
    CONSTRAINT FK_CTHD_SanPham FOREIGN KEY (MaSP)
        REFERENCES SanPham(MaSP)
);
CREATE TABLE PhieuXuat (
    SoPX VARCHAR(20) PRIMARY KEY,
    MaCH VARCHAR(20) NOT NULL,
    SoHD VARCHAR(20) NULL,
    NgayXuat DATE NOT NULL,
    TriGiaXuat FLOAT NULL,
    MaNV VARCHAR(20) NULL,
    CONSTRAINT FK_PhieuXuat_CuaHang FOREIGN KEY (MaCH)
        REFERENCES CuaHang(MaCH),
    CONSTRAINT FK_PhieuXuat_HoaDon FOREIGN KEY (SoHD)
        REFERENCES HoaDon(SoHD),
    CONSTRAINT FK_PhieuXuat_NhanVien FOREIGN KEY (MaNV)
        REFERENCES NhanVien(MaNV)
);
CREATE TABLE CTPX (
    SoPX VARCHAR(20) NOT NULL,
    MaSP VARCHAR(20) NOT NULL,
    SoLuongPX INT NULL,
    DonGiaPX FLOAT NULL,
    TTienPX FLOAT NULL,
    CONSTRAINT PK_ChiTietPhieuXuat PRIMARY KEY (SoPX, MaSP),
    CONSTRAINT FK_CTPX_PhieuXuat FOREIGN KEY (SoPX)
        REFERENCES PhieuXuat(SoPX),
    CONSTRAINT FK_CTPX_SanPham FOREIGN KEY (MaSP)
        REFERENCES SanPham(MaSP)
);
CREATE TABLE ButToan (
    MaBT VARCHAR(20) PRIMARY KEY,
    DienGiai_BT NVARCHAR(255) NULL,
    TKNo VARCHAR(20) NULL,
    TKCo VARCHAR(20) NULL,
    SoTien FLOAT NULL,
    SoPN VARCHAR(20) NULL,
    SoPX VARCHAR(20) NULL,
    SoHD VARCHAR(20) NULL,
    CONSTRAINT FK_ButToan_TKNo FOREIGN KEY (TKNo)
        REFERENCES TietKhoan(MaTietKhoan),
    CONSTRAINT FK_ButToan_TKCo FOREIGN KEY (TKCo)
        REFERENCES TietKhoan(MaTietKhoan),
    CONSTRAINT FK_ButToan_PhieuNhap FOREIGN KEY (SoPN)
        REFERENCES PhieuNhap(SoPN),
    CONSTRAINT FK_ButToan_PhieuXuat FOREIGN KEY (SoPX)
        REFERENCES PhieuXuat(SoPX),
    CONSTRAINT FK_ButToan_HoaDon FOREIGN KEY (SoHD)
        REFERENCES HoaDon(SoHD)
);
CREATE TABLE BaoCao (
    MaBC VARCHAR(20) PRIMARY KEY,
    MaNV VARCHAR(20) NOT NULL,
    TenBC NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_BaoCao_NhanVien FOREIGN KEY (MaNV)
        REFERENCES NhanVien(MaNV)
);
INSERT INTO LoaiSP (MaLoaiSP, TenLoaiSP) VALUES
(N'L001', N'Cân điện tử'),
(N'L002', N'Máy sấy tóc'),
(N'L003', N'Chăm sóc răng miệng'),
(N'L004', N'Máy lọc không khí'),
(N'L005', N'Quạt máy'),
(N'L006', N'Bàn ủi'),
(N'L007', N'Đèn'),
(N'L008', N'Máy hút bụi'),
(N'L009', N'Nồi chiên không dầu/ ngập dầu'),
(N'L010', N'Máy xay/ máy vắt');
INSERT INTO MauSac (MaMauSac, TenMauSac) VALUES
(N'MS001', N'Trắng'),
(N'MS002', N'Đen'),
(N'MS003', N'Xám'),
(N'MS004', N'Tím'),
(N'MS005', N'Be'),
(N'MS006', N'Xanh dương'),
(N'MS007', N'Ngà'),
(N'MS008', N'Xanh lá');
INSERT INTO SanPham (MaSP, TenSP, MoTa, DVT, NgayRaMat, GiaNhap, GiaBanDuKien, DienAp, KichThuoc, TrongLuong, CongSuat, DungTich, Hinh, MaLoaiSP, MaMauSac) VALUES
(N'SP001', N'Cân Sức Khỏe LocknLock Dùng Cho Gia Đình', N'Cân Sức Khỏe LocknLock Dùng Trong Gia Đình giúp theo dõi các mục tiêu sức khỏe của mình', N'Cái', '2022-10-04', 201600, 288000, NULL, N'280x290x55mm', NULL, NULL, NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\001.png', N'L001', N'MS001'),
(N'SP002', N'CÂN ĐIỆN TỬ BLU CN 5', N'CÂN ĐIỆN TỬ BLU CN 5', N'Cái', '2022-10-19', 389900, 557000, NULL, N'310x300x21mm', NULL, NULL, NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\002.png', N'L001', N'MS002'),
(N'SP003', N'MÁY SẤY TÓC TẠO KIỂU LOCK&LOCK Multi Hair Dryer Công Nghệ ION Âm', N'Máy Sấy Tóc Tạo Kiểu LocknLock Multi Hair Dryer Công Nghệ ION Âm - 5 Đầu Sấy - Màu Xám ENA426GRY', N'Cái', '2022-12-06', 1470700, 2101000, N'220V', N'305x56x165mm', N'0,75kg', N'1300W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\003.png', N'L002', N'MS003'),
(N'SP004', N'Máy sấy tóc Jenniferoom, động cơ BLDC, công nghệ ion âm', N'Máy sấy tóc Jenniferoom công suất 1450W, động cơ BLDC, công nghệ ion âm - 2 Màu - JRG-HD1502', N'Cái', '2024-08-01', 1965600, 2808000, N'220V', N'65x142x280mm', N'0,53kg', N'1450W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\004.png', N'L002', N'MS004'),
(N'SP005', N'Máy tăm nước không dây LOCK&LOCK Cordless Oral Irrigator', N'Máy Tăm Nước Không Dây LocknLock Cordless Oral Irrigator, 200ml - Màu Xanh Da Trời - ENR156BLU', N'Cái', '2022-07-20', 513800, 734000, N'5V', N'65x85x205mm', N'0,33kg', N'3W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\005.png', N'L003', N'MS006'),
(N'SP006', N'Bàn Chải Đánh Răng Điện LOCK&LOCK Electric Toothbrush', N'Bàn Chải Đánh Răng Điện LocknLock Electric Toothbrush 3.7V, 1.8W - Màu Trắng - ENR331WHT', N'Cái', '2022-05-05', 529200, 756000, N'3,7V', N'27,8x27,8x254mm', N'0,32kg', N'1,8W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\006.png', N'L003', N'MS006'),
(N'SP007', N'Bộ Lọc Của Máy Lọc Không Khí Air Further Filter', N'Bộ Lọc Của Máy Lọc Không Khí Air Furifier Filter, 165x165x220mm - LocknLock - ENP126_FLT', N'Cái', '2022-10-03', 367500, 525000, NULL, N'220x165x165mm', N'0,75kg', NULL, NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\007.png', N'L004', N'MS001'),
(N'SP008', N'Máy Lọc Không Khí LOCK&LOCK Coverage', N'Máy Lọc Không Khí LocknLock Coverage màu trắng 220 - 240V, 50/60Hz, 23W, Cadr 130㎥/H, Coverage 16㎡ ', N'Cái', '2022-07-22', 2021600, 2888000, N'220V', N'195x195x398mm', N'8,3kg', N'23W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\008.png', N'L004', N'MS001'),
(N'SP009', N'Quạt sạc điện gấp gọn Jenniferoom Foldable', N'Quạt sạc điện gấp gọn Jenniferoom Foldable fan 8W, 8000mAh - Màu be JRL-FF085COM', N'Cái', '2022-09-18', 1877400, 2682000, N'5V', N'255x255x930mm', N'2,26kg', N'8W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\009.png', N'L005', N'MS005'),
(N'SP010', N'Quạt Tuần Hoàn Không Khí LOCK&LOCK Desktop Circulation Fan', N'Quạt Tuần Hoàn Không Khí LocknLock Desktop Circulation Fan - 220V, 50Hz, 28W - Màu Ngà - ENF156IVY', N'Cái', '2022-11-12', 679000, 970000, N'220V', N'260x238x325mm', N'1,68kg', N'28W', NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\010.png', N'L005', N'MS007'),
(N'SP011', N'Bàn ủi hơi nước LOCK&LOCK Garment steamer', N'Bàn ủi hơi nước LocknLock Garment steamer -ENI218IVY', N'Cái', '2023-02-15', 1568000, 2240000, N'220V', N'150x265x225mm', N'1,56kg', N'1630W', N'0,8L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\011.png', N'L006', N'MS007'),
(N'SP012', N'Bàn Là Hơi Nước Cầm Tay LOCK&LOCK Handy Steamer', N'Bàn Là Hơi Nước Cầm Tay LocknLock Handy Steamer, 220 - 240 V, 50/60 Hz, 1500W, 300Ml - Màu Trắng - ENI222WHT', N'Cái', '2024-08-20', 766500, 1095000, N'220V', N'110x115x280mm', NULL, N'1500W', N'0,3L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\012.png', N'L006', N'MS001'),
(N'SP013', N'Đèn Bàn Locknlock Mono(Không Có Bóng Đèn)', N'Đèn Bàn Locknlock Mono(Không Có Bóng Đèn) - 180X180X300 - Grn - Cn - 6 - Mixed - Single - LIT116GRN', N'Cái', '2025-12-08', 185500, 265000, NULL, N'180x180x300mm', NULL, NULL, NULL, N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\013.png', N'L007', N'MS008'),
(N'SP014', N'Máy Hút Bụi Locknlock', N'Máy Hút BụI Locknlock 0.4L, 400W, 220V, 50Hz - Màu Đen - ENV336BLK', N'Cái', '2024-10-25', 1437100, 2053000, N'220V', NULL, NULL, N'400W', N'0,4L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\014.png', N'L008', N'MS002'),
(N'SP015', N'Máy Hút Bụi Không Dây Dùng Pin Sạc LocknLock', N'Máy Hút Bụi Không Dây Dùng Pin Sạc LocknLock ENV356GRY', N'Cái', '2023-10-02', 4001900, 5717000, NULL, N'260x210x1150mm', N'4,2kg', N'350W', N'0,5L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\015.png', N'L008', N'MS003'),
(N'SP016', N'Máy hút bụi giường nệm LocknLock', N'Máy hút bụi giường nệm LocknLock 300W, 0.5L - Màu ngà - ENV818IVY', N'Cái', '2024-08-15', 1465100, 2093000, N'220V', N'250x190x283mm', NULL, N'300W', N'0,5L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\016.png', N'L008', N'MS007'),
(N'SP017', N'Nồi Chiên Không Dầu Kết Hợp Chức Năng Hấp LocknLock - Màu ngân', N'Nồi Chiên Không Dầu Kết Hợp Chức Năng Hấp LocknLock EJF881', N'Cái', '2023-08-03', 2044700, 2921000, N'220V', N'400x394x324mm', NULL, N'1800W', N'7L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\017.png', N'L009', N'MS007'),
(N'SP018', N'Nồi Chiên Không Dầu Kết Hợp Chức Năng Hấp LocknLock - Màu đen', N'Nồi Chiên Không Dầu Kết Hợp Chức Năng Hấp LocknLock EJF881', N'Cái', '2023-08-03', 2044700, 2921000, N'220V', N'400x394x324mm', NULL, N'1800W', N'7L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\018.png', N'L009', N'MS002'),
(N'SP019', N'Nồi Chiên Không Dầu LocknLock Air Fryer', N'Nồi chiên không dầu LocknLock EJF284BLK không chỉ thu hút bởi thiết kế sang trọng mà còn bởi dung tích lớn và tính năng hiện đại.', N'Cái', '2024-11-20', 1612100, 2303000, N'220V', N'325x314x376mm', N'6kg', N'1700W', N'5,5L', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\019.png', N'L009', N'MS002'),
(N'SP020', N'Máy Làm Sữa Hạt Đa Năng LocknLock / Banaco Heating Blender', N'Máy Làm Sữa Hạt Đa Năng Locknlock Bianco Heating Blender 1.75L, 800W, 220V, 50Hz - Màu ngà - EJM486IVY', N'Cái', '2022-05-05', 1726200, 2466000, N'220V', N'32.4x22.1x3.9cm', N'3,9kg', N'800W', N'1,75l', N'D:\\K3_2025\\HTTTKT\\LnL_HTTTKT\\Media\\020.png', N'L010', N'MS007');
INSERT INTO CuaHang (MaCH, TenCH, DiaChi, SDT) VALUES
(N'CH001', N'Vạn Hạnh Mall', N'Tầng 4, 11 Sư Vạn Hạnh, P. 12, Q.10, Tp. Hồ Chí Minh', N'028 3636 7445'),
(N'CH002', N'Nowzone', N'Tầng 2, Nowzone, 235 Nguyễn Văn Cừ, P.Nguyễn Cư Trinh, Q.1, Tp. Hồ Chí Minh', N'028 3925 8197'),
(N'CH003', N'Crescent Mall', N'Tầng 4, TTTM Crescent mall, 101 Tôn Dật Tiên, Phú Mỹ Hưng, Q.7, Tp. Hồ Chí Minh', N'028 5413 7359'),
(N'CH004', N'Vincom Mega Mall L2-04A', N'Tầng 2, KĐTM Vinhomes Smart City, P.Đại Mỗ, Q. Nam Từ Liêm, Tp. Hà Nội', N'024-3202-2208'),
(N'CH005', N'Vincom Center Tt', N'Tầng hầm B1, Số 458 Minh Khai, Q. Hai Bà Trưng, Hà Nội', N'024-3200-2209');
INSERT INTO BoPhan (MaBP, MaCH, TenBP, SDT_BP, Email_BP) VALUES
(N'BP001', N'CH001', N'Bộ phận Kế toán', N'028 3636 7446', N'ketoan.ch001@email.com'),
(N'BP002', N'CH001', N'Bộ phận Bán hàng', N'028 3636 7447', N'banhang.ch001@email.com'),
(N'BP003', N'CH001', N'Bộ phận Kho vận', N'028 3925 8198', N'khovn.ch001@email.com'),
(N'BP004', N'CH001', N'Bộ phận Kỹ thuật', N'028 5413 7360', N'kythuat.ch001@email.com'),
(N'BP005', N'CH001', N'Bộ phận mua hàng', N'024 3200 2210', N'muahang.ch001@email.com'),
(N'BP006', N'CH002', N'Bộ phận Bán hàng', N'028 5413 7361', N'banhang.ch002@email.com'),
(N'BP007', N'CH002', N'Bộ phận Kế toán', N'024 3200 2211', N'ketoan.ch002@email.com'),
(N'BP008', N'CH003', N'Bộ phận Bán hàng', N'028 5413 7362', N'banhang.ch003@email.com'),
(N'BP009', N'CH003', N'Bộ phận Kho vận', N'024 3200 2212', N'khovn.ch003@email.com'),
(N'BP010', N'CH004', N'Bộ phận Kỹ thuật', N'028 5413 7363', N'kythuat.ch004@email.com');
INSERT INTO TonKho_CuaHang(MaCH, MaSP, ThangTK, NamTK, TonDK, TriGiaTonDK, NhapTK, TriGiaNhapTK, XuatTK, TriGiaXuatTK, TonCK, TriGiaTonCK) VALUES
(N'CH001', N'SP001', 1, 2025, 10, 2016000, 2, 403200, 5, 1008000, 7, 1411200),
(N'CH001', N'SP004', 1, 2025, 10, 19656000, 2, 3931200, 0, 0, 12, 23587200),
(N'CH001', N'SP009', 1, 2025, 10, 18774000, 5, 9387000, 3, 5632200, 12, 22528800),
(N'CH001', N'SP017', 1, 2025, 15, 30670500, 10, 20447000, 8, 16357600, 17, 34759900),
(N'CH004', N'SP002', 1, 2025, 30, 11697000, 10, 3899000, 5, 1949500, 35, 13646500),
(N'CH004', N'SP003', 1, 2025, 10, 14707000, 5, 7353500, 2, 2941400, 13, 19119100),
(N'CH004', N'SP015', 1, 2025, 5, 20009500, 0, 0, 4, 16007600, 1, 4001900);
INSERT INTO KhachHang (MaKH, TenKH, SDT_KH, Email_KH, NgaySinh_KH) VALUES
(N'KH001', N'Trần Văn An', N'0901234567', N'an.tv@email.com', '1995-12-15'),
(N'KH002', N'Lê Thị Bình', N'0987654321', N'binh.lt@email.com', '1988-05-20'),
(N'KH003', N'Nguyễn Hoàng Cường', N'0345678901', N'cuong.nh@email.com', '2001-08-01'),
(N'KH004', N'Phạm Thu Dung', N'0778899001', N'dung.pt@email.com', '1990-03-25'),
(N'KH005', N'Võ Minh Hùng', N'0868889990', N'hung.vm@email.com', '1975-11-10');
INSERT INTO TaiKhoan (MaTaiKhoan, TenTaiKhoan) VALUES
(N'111', N'Tiền mặt'),
(N'112', N'Tiền gửi ngân hàng'),
(N'113', N'Tiền đang chuyển'),
(N'131', N'Phải thu khách hàng'),
(N'133', N'Thuế GTGT được khấu trừ'),
(N'138', N'Phải thu khác'),
(N'156', N'Hàng hóa'),
(N'331', N'Phải trả cho người bán'),
(N'333', N'Thuế và các khoản phải nộp cho Nhà nước'),
(N'511', N'Doanh thu'),
(N'632', N'Giá vốn hàng bán'),
(N'641', N'Chi phí bán hàng'),
(N'642', N'Chi phí quản lý doanh nghiệp');
INSERT INTO TieuKhoan (MaTieuKhoan, MaTaiKhoan, TenTieuKhoan) VALUES
(N'1111', N'111', N'Tiền Việt Nam'),
(N'1121', N'112', N'Tiền Việt Nam gửi ngân hàng'),
(N'1131', N'113', N'Tiền Việt đang chuyển'),
(N'1311', N'131', N'Phải thu khách hàng'),
(N'131T', N'131', N'Phải thu khách hàng'), -- Giả định là một tiểu khoản đặc biệt của 131
(N'1331', N'133', N'Thuế GTGT được khấu trừ của hàng hóa'),
(N'1381', N'138', N'Tài sản thiếu chờ xử lý'),
(N'1561', N'156', N'Giá mua hàng hóa'),
(N'1562', N'156', N'Chi phí thu mua hàng hóa'),
(N'331B', N'331', N'Phải trả người bán'), -- Giả định là một tiểu khoản đặc biệt của 331
(N'3331', N'333', N'Thuế GTGT phải nộp'),
(N'3332', N'333', N'Thuế tiêu thụ đặc biệt'),
(N'5111', N'511', N'Doanh thu bán hàng hóa'),
(N'632V', N'632', N'Giá vốn hàng bán'); -- Giả định là một tiểu khoản đặc biệt của 632
INSERT INTO TietKhoan (MaTietKhoan, MaTieuKhoan, TenTietKhoan) VALUES
(N'1111M', N'1111', N'Tiền mặt Việt Nam'),
(N'1121H', N'1121', N'Tiền Việt nam gửi ngân hàng'),
(N'1311K', N'1311', N'Phải thu khách mua hàng'),
(N'131TK', N'131T', N'Phải thu khách hàng'),
(N'1331T', N'1331', N'Thuế GTGT được khấu trừ của hàng hóa'),
(N'1381H', N'1381', N'Hàng hóa thiếu chờ xử lý'),
(N'1561B', N'1561', N'Cân điện tử'),
(N'1561S', N'1561', N'Máy sấy tóc'),
(N'331BH', N'331B', N'Phải trả cho nhà cung cấp'),
(N'3331T', N'3331', N'Thuế GTGT phải nộp nhà nước'),
(N'5111B', N'5111', N'Doanh thu bán hàng'),
(N'5111S', N'5111', N'Doanh thu máy sấy tóc'),
(N'632VB', N'632V', N'Giá vốn cân điện tử'),
(N'632VS', N'632V', N'Giá vốn máy sấy tóc');
INSERT INTO SoDuDK (MaTietKhoan, ThangDK, NamDK, SoTienDK, DuNo) VALUES
(N'1111M', 1, 2025, 56000000, N'N'),
(N'1121H', 1, 2025, 67000000, N'N'),
(N'1331T', 1, 2025, 1200000, N'N'),
(N'1381H', 1, 2025, 0, N'N'),
(N'1561B', 1, 2025, 45000000, N'N'),
(N'1561S', 1, 2025, 12500000, N'N'),
(N'331BH', 1, 2025, 200000000, N'C'),
(N'3331T', 1, 2025, 9420000, N'C');
INSERT INTO PhieuNhap (SoPN, MaCH, NgayNhap, TriGiaNhap, MaNV) VALUES
(N'PN001', N'CH001', '2025-10-05', 31850000, N'NV003'),
(N'PN002', N'CH004', '2025-10-10', 11252500, N'NV003'),
(N'PN003', N'CH001', '2025-10-20', 2016000, N'NV008'),
(N'PN004', N'CH002', '2025-10-25', 16121000, N'NV008'),
(N'PN005', N'CH003', '2025-10-28', 4001900, N'NV009');
INSERT INTO CTPN (SoPN, MaSP, SoLuongPN, DonGiaPN, TTienPN) VALUES
(N'PN001', N'SP001', 5, 201600, 1008000),
(N'PN001', N'SP009', 5, 1877400, 9387000),
(N'PN001', N'SP017', 10, 2044700, 20447000),
(N'PN002', N'SP002', 10, 389900, 3899000),
(N'PN002', N'SP003', 5, 1470700, 7353500),
(N'PN003', N'SP001', 10, 201600, 2016000),
(N'PN004', N'SP019', 10, 1612100, 16121000),
(N'PN005', N'SP015', 1, 4001900, 4001900);
INSERT INTO TaiKhoanNguoiDung (MaTKND, TenTKND, MatKhau, Quyen) VALUES
(N'TK001', N'banhang01', N'banhang01', N'banhang'),
(N'TK002', N'ketoan02', N'ketoan02', N'ketoan'),
(N'TK003', N'kho03', N'kho03', N'kho'),
(N'TK004', N'admin04', N'admin04', N'admin'),
(N'TK005', N'muahang05', N'muahang05', N'muahang'),
(N'TK006', N'banhang06', N'banhang06', N'banhang'),
(N'TK007', N'banhang07', N'banhang07', N'banhang'),
(N'TK008', N'kho08', N'kho08', N'kho'),
(N'TK009', N'kho09', N'kho09', N'kho'),
(N'TK010', N'kho10', N'kho10', N'kho');
INSERT INTO NhanVien (MaNV, MaBP, MaTKND, TenNV, SDT_NV, Email_NV) VALUES
(N'NV001', N'BP002', N'TK001', N'Hoàng Văn Nam', N'0912345678', N'nam.hv@abc.com'),
(N'NV002', N'BP001', N'TK002', N'Trần Thanh Nga', N'0945678901', N'nga.tt@abc.com'),
(N'NV003', N'BP003', N'TK003', N'Lê Minh Tuấn', N'0956789012', N'tuan.lm@abc.com'),
(N'NV004', N'BP004', N'TK004', N'Phan Văn An', N'0900000001', N'an.pv@abc.com'),
(N'NV005', N'BP005', N'TK005', N'Đỗ Thị Hương', N'0923456789', N'huong.dt@abc.com'),
(N'NV006', N'BP002', N'TK006', N'Nguyễn Thị Hồng', N'0933445566', N'hong.nt@abc.com'),
(N'NV007', N'BP002', N'TK007', N'Vũ Đình Thanh', N'0987654321', N'thanh.vd@abc.com'),
(N'NV008', N'BP003', N'TK008', N'Nguyễn Thị Thanh', N'0935123456', N'thanh.nt@abc.com'),
(N'NV009', N'BP003', N'TK009', N'Hoàng Minh Đức', N'0948987654', N'duc.hm@abc.com'),
(N'NV010', N'BP003', N'TK010', N'Vũ Đình Khôi', N'0971234567', N'khoi.vd@abc.com');
INSERT INTO HoaDon (SoHD, MaNV, MaKH, NgayLapHD, TriGiaHD, VAT, TongTienHD) VALUES
(N'HD001', N'NV001', N'KH001', '2025-06-06', 5000000, 500000, 5500000),
(N'HD002', N'NV001', N'KH002', '2025-06-11', 2500000, 250000, 2750000),
(N'HD003', N'NV006', N'KH003', '2025-07-15', 18000000, 1800000, 19800000),
(N'HD004', N'NV007', N'KH004', '2025-07-18', 7500000, 750000, 8250000),
(N'HD005', N'NV001', N'KH005', '2025-08-22', 1000000, 100000, 1100000),
(N'HD006', N'NV001', N'KH001', '2025-09-01', 7718000, 771800, 8490000),
(N'HD007', N'NV006', N'KH002', '2025-09-05', 5459000, 545900, 6004900),
(N'HD008', N'NV007', N'KH003', '2025-10-12', 3968000, 396800, 4364800),
(N'HD009', N'NV001', N'KH001', '2025-10-25', 6890000, 689000, 7579000),
(N'HD010', N'NV006', N'KH002', '2025-11-08', 5122000, 512200, 5634200),
(N'HD011', N'NV007', N'KH003', '2025-11-19', 4376000, 437600, 4813600),
(N'HD012', N'NV001', N'KH001', '2025-11-03', 6050000, 605000, 6655000);
INSERT INTO CTHD (SoHD, MaSP, SoLuongHD, DonGiaHD, TTienHD) VALUES
(N'HD001', N'SP002', 5, 1000000, 5000000),
(N'HD002', N'SP003', 2, 1250000, 2500000),
(N'HD003', N'SP017', 10, 1800000, 18000000),
(N'HD004', N'SP019', 5, 1500000, 7500000),
(N'HD005', N'SP001', 4, 250000, 1000000),
(N'HD006', N'SP001', 1, 288000, 288000),
(N'HD006', N'SP005', 2, 734000, 1468000),
(N'HD006', N'SP007', 1, 186000, 186000),
(N'HD006', N'SP008', 2, 2888000, 5776000),
(N'HD007', N'SP003', 1, 2101000, 2101000),
(N'HD007', N'SP004', 1, 2808000, 2808000),
(N'HD007', N'SP006', 2, 275000, 550000),
(N'HD008', N'SP002', 2, 643000, 1286000),
(N'HD008', N'SP009', 1, 2682000, 2682000),
(N'HD009', N'SP005', 4, 995000, 3980000),
(N'HD009', N'SP010', 3, 970000, 2910000),
(N'HD010', N'SP006', 3, 742000, 2226000),
(N'HD010', N'SP008', 1, 2888000, 2888000),
(N'HD011', N'SP001', 1, 174000, 174000),
(N'HD011', N'SP003', 2, 2101000, 4202000),
(N'HD012', N'SP004', 1, 2808000, 2808000),
(N'HD012', N'SP007', 2, 525000, 1050000),
(N'HD012', N'SP010', 2, 1096000, 2192000);
INSERT INTO PhieuXuat (SoPX, MaCH, SoHD, NgayXuat, TriGiaXuat, MaNV) VALUES
(N'PX001', N'CH001', N'HD001', '2025-10-06', 5000000, N'NV009'),
(N'PX002', N'CH001', N'HD002', '2025-10-11', 2500000, N'NV009'),
(N'PX003', N'CH004', N'HD003', '2025-10-15', 18000000, N'NV010'),
(N'PX004', N'CH003', N'HD004', '2025-10-18', 7500000, N'NV010'),
(N'PX005', N'CH001', N'HD005', '2025-10-22', 1000000, N'NV003');
INSERT INTO CTPX (SoPX, MaSP, SoLuongPX, DonGiaPX, TTienPX) VALUES
(N'PX001', N'SP002', 5, 1000000, 5000000),
(N'PX002', N'SP003', 2, 1250000, 2500000),
(N'PX003', N'SP017', 10, 1800000, 18000000),
(N'PX004', N'SP019', 5, 1500000, 7500000),
(N'PX005', N'SP001', 4, 250000, 1000000);
INSERT INTO ButToan (MaBT, DienGiai_BT, TKNo, TKCo, SoTien, SoPN, SoPX, SoHD) VALUES
(N'BT001A', N'Ghi nhận doanh thu bán hàng HĐ001', N'1311K', N'5111B', 5000000, NULL, NULL, N'HD001'),
(N'BT001B', N'Ghi nhận thuế GTGT phải nộp HĐ001', N'1311K', N'3331T', 500000, NULL, NULL, N'HD001'),
(N'BT001C', N'Ghi nhận giá vốn hàng bán PX001', N'632VB', N'1561B', 5000000, NULL, N'PX001', NULL),
(N'BT002A', N'Ghi nhận doanh thu bán hàng HĐ002', N'1311K', N'5111B', 2500000, NULL, NULL, N'HD002'),
(N'BT002B', N'Ghi nhận thuế GTGT phải nộp HĐ002', N'1311K', N'3331T', 250000, NULL, NULL, N'HD002'),
(N'BT002C', N'Ghi nhận giá vốn hàng bán PX002', N'632VB', N'1561B', 2500000, NULL, N'PX002', NULL),
(N'BT003A', N'Ghi nhận doanh thu bán hàng HĐ003', N'1311K', N'5111B', 18000000, NULL, NULL, N'HD003'),
(N'BT003B', N'Ghi nhận thuế GTGT phải nộp HĐ003', N'1311K', N'3331T', 1800000, NULL, NULL, N'HD003'),
(N'BT003C', N'Ghi nhận giá vốn hàng bán PX003', N'632VB', N'1561B', 18000000, NULL, N'PX003', NULL),
(N'BT004A', N'Ghi nhận doanh thu bán hàng HĐ004', N'1311K', N'5111B', 7500000, NULL, NULL, N'HD004'),
(N'BT004B', N'Ghi nhận thuế GTGT phải nộp HĐ004', N'1311K', N'3331T', 750000, NULL, NULL, N'HD004'),
(N'BT004C', N'Ghi nhận giá vốn hàng bán PX004', N'632VB', N'1561B', 7500000, NULL, N'PX004', NULL),
(N'BT005A', N'Ghi nhận doanh thu bán hàng HĐ005', N'1311K', N'5111B', 1000000, NULL, NULL, N'HD005'),
(N'BT005B', N'Ghi nhận thuế GTGT phải nộp HĐ005', N'1311K', N'3331T', 100000, NULL, NULL, N'HD005'),
(N'BT005C', N'Ghi nhận giá vốn hàng bán PX005', N'632VB', N'1561B', 1000000, NULL, N'PX005', NULL),
(N'BT006A', N'Ghi nhận hàng hóa nhập kho PN001 (chưa VAT)', N'1561B', N'331BH', 31850000, N'PN001', NULL, NULL),
(N'BT006B', N'Ghi nhận VAT đầu vào được khấu trừ PN001', N'1331T', N'331BH', 3185000, N'PN001', NULL, NULL),
(N'BT007A', N'Ghi nhận hàng hóa nhập kho PN002 (chưa VAT)', N'1561B', N'331BH', 11252500, N'PN002', NULL, NULL),
(N'BT007B', N'Ghi nhận VAT đầu vào được khấu trừ PN002', N'1331T', N'331BH', 1125250, N'PN002', NULL, NULL),
(N'BT008A', N'Ghi nhận hàng hóa nhập kho PN003 (chưa VAT)', N'1561B', N'331BH', 2016000, N'PN003', NULL, NULL),
(N'BT008B', N'Ghi nhận VAT đầu vào được khấu trừ PN003', N'1331T', N'331BH', 201600, N'PN003', NULL, NULL),
(N'BT009A', N'Ghi nhận hàng hóa nhập kho PN004 (chưa VAT)', N'1561B', N'331BH', 16121000, N'PN004', NULL, NULL),
(N'BT009B', N'Ghi nhận VAT đầu vào được khấu trừ PN004', N'1331T', N'331BH', 1612100, N'PN004', NULL, NULL),
(N'BT010A', N'Ghi nhận hàng hóa nhập kho PN005 (chưa VAT)', N'1561B', N'331BH', 4001900, N'PN005', NULL, NULL),
(N'BT010B', N'Ghi nhận VAT đầu vào được khấu trừ PN005', N'1331T', N'331BH', 400190, N'PN005', NULL, NULL);
INSERT INTO BaoCao (MaBC, MaNV, TenBC) VALUES
(N'BC001', N'NV002', N'Báo cáo Doanh thu tháng 1/2025'),
(N'BC002', N'NV002', N'Báo cáo Doanh thu tháng 2/2025'),
(N'BC003', N'NV002', N'Báo cáo Doanh thu tháng 3/2025'),
(N'BC004', N'NV004', N'Báo cáo Doanh thu tháng 4/2025'),
(N'BC005', N'NV004', N'Báo cáo Doanh thu tháng 5/2025');

CREATE VIEW Doanhthu AS
SELECT
    -- Nhóm theo Tháng và Năm
    FORMAT(HD.NgayLapHD, 'yyyy-MM') AS SalesMonth, 

    -- Tên Sản phẩm (TênSP)
    SP.TenSP, 

    -- Tính tổng Doanh thu
    SUM(CT.TTienHD) AS TotalRevenue 
FROM
    HoaDon HD
INNER JOIN
    CTHD CT ON HD.SoHD = CT.SoHD
INNER JOIN
    SanPham SP ON CT.MaSP = SP.MaSP -- KẾT NỐI VỚI BẢNG SẢN PHẨM
GROUP BY
    FORMAT(HD.NgayLapHD, 'yyyy-MM'),
    SP.TenSP;
select*from Doanhthu


