CREATE DATABASE WWSGO
GO
USE WWSGO
GO
/****** Object:  Table [dbo].[bode]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bode](
	[TenBoDe] [varchar](100) NOT NULL,
	[NgayTao] [date] NOT NULL,
	[NoiDung] [varchar](max) NOT NULL,
	[ThangDiem] [int] NOT NULL,
	[ThuTu] [smallint] NULL,
	[MaBoDe] [int] IDENTITY(1,1) NOT NULL,
	[MaGiaoVien] [int] NOT NULL,
 CONSTRAINT [PK_MABODE] PRIMARY KEY CLUSTERED 
(
	[MaBoDe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bomon]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bomon](
	[MaHe] [int] NOT NULL,
	[TenBoMon] [varchar](255) NOT NULL,
	[NgayTao] [date] NOT NULL,
	[MaBoMon] [int] IDENTITY(1,1) NOT NULL,
	[TruongBoMon] [int] NULL,
 CONSTRAINT [PK_BOMON] PRIMARY KEY CLUSTERED 
(
	[MaBoMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cauhoi]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cauhoi](
	[MaGiaoVien] [int] NOT NULL,
	[MaBoDe] [int] NULL,
	[MaBoMon] [int] NOT NULL,
	[NoiDung] [varchar](255) NOT NULL,
	[ThangDiem] [float] NOT NULL,
	[MucDo] [int] NOT NULL,
	[LuaChon] BIT NOT NULL DEFAULT 0,
	[NgayTao] [date] NOT NULL,
	[TrangThai] BIT NOT NULL DEFAULT 0,
	[ThuTu] [int] NULL,
	[MaCauHoi] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MACAUHOI] PRIMARY KEY CLUSTERED 
(
	[MaCauHoi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cauhoi_hocky]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cauhoi_hocky](
	[MaHocKy] [int] NOT NULL,
	[MaCauHoi] [int] NOT NULL,
 CONSTRAINT [PK_CAUHOI_HOCKY] PRIMARY KEY CLUSTERED 
(
	[MaHocKy] ASC,
	[MaCauHoi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[chucvu]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[chucvu](
	[TenChucVu] [varchar](255) NOT NULL,
	[NgayNhamChuc] [date] NULL,
	[NgayMienNhiem] [date] NULL,
	[MaChucVu] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MACHUCVU] PRIMARY KEY CLUSTERED 
(
	[MaChucVu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[giaovien]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[giaovien](
	[MaChucVu] [int] NOT NULL,
	[MaBoMon] [int] NULL,
	[TenGiaoVien] [varchar](255) NOT NULL,
	[NgaySinh] [date] NOT NULL,
	[GioiTinh] BIT NOT NULL DEFAULT 0,
	[NgayVaoLam] [date] NOT NULL,
	[GiaoVienQuanLy] [int] NULL,
	[TrangThai] BIT NOT NULL DEFAULT 0,
	[cmnd] [varchar](20) NOT NULL unique,
	[MaGiaoVien] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MAGIAOVIEN] PRIMARY KEY CLUSTERED 
(
	[MaGiaoVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_giaovien] UNIQUE NONCLUSTERED 
(
	[cmnd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[gop_y]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[gop_y](
	[MaGiaoVien] [int] NOT NULL,
	[MaCauHoi] [int] NOT NULL,
	[NoiDung] [varchar](max) NOT NULL,
	[NgayGopY] [date] NOT NULL,
	[MaGopY] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MAGOPY] PRIMARY KEY CLUSTERED 
(
	[MaGopY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[he]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[he](
	[MaHe] [int] IDENTITY(1,1) NOT NULL,
	[TenHe] [varchar](255) NOT NULL,
	[NgayTao] [date] NULL,
 CONSTRAINT [PK_MAHE] PRIMARY KEY CLUSTERED 
(
	[MaHe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[hocky]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hocky](
	[TenHocKy] [nvarchar](255) NULL,
	[NgayBatDau] [date] NOT NULL,
	[NgayKetThuc] [date] NOT NULL,
	[MaHocKy] [int] IDENTITY(1,1) NOT NULL,
	[MaNienKhoa] [int] NOT NULL,
 CONSTRAINT [PK_MAHOCKY] PRIMARY KEY CLUSTERED 
(
	[MaHocKy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[nienkhoa]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[nienkhoa](
	[TenNienKhoa] [varchar](255) NOT NULL,
	[ThoiGianBatDau] [date] NOT NULL,
	[ThoiGianKetThuc] [date] NOT NULL,
	[MaNienKhoa] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MANIENKHOA] PRIMARY KEY CLUSTERED 
(
	[MaNienKhoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[phanquyen]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[phanquyen](
	[TenPhanQuyen] [varchar](255) NOT NULL,
	[NgayTao] [date] NOT NULL,
	[MaPhanQuyen] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_MAPHANQUYEN] PRIMARY KEY CLUSTERED 
(
	[MaPhanQuyen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[phanquyen_giaovien]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phanquyen_giaovien](
	[MaPhanQuyen] [int] NOT NULL,
	[MaGiaoVien] [int] NOT NULL,
 CONSTRAINT [PK_PQ_GV] PRIMARY KEY CLUSTERED 
(
	[MaPhanQuyen] ASC,
	[MaGiaoVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[traloi]    Script Date: 31/07/2017 9:26:08 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[traloi](
	[MaCauHoi] [int] NOT NULL,
	[NoiDung] [varchar](max) NOT NULL,
	[DapAn] [BIT] NOT NULL DEFAULT 0,
	[TenTraLoi] [varchar](2) NOT NULL,
 CONSTRAINT [PK_TENTRALOI_MACAUHOI] PRIMARY KEY CLUSTERED 
(
	[MaCauHoi] ASC,
	[TenTraLoi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bode] ADD  DEFAULT ('0000-00-00') FOR [NgayTao]
GO
ALTER TABLE [dbo].[bomon] ADD  DEFAULT ('0000-00-00') FOR [NgayTao]
GO
ALTER TABLE [dbo].[cauhoi] ADD  DEFAULT ('0000-00-00') FOR [NgayTao]
GO
ALTER TABLE [dbo].[chucvu] ADD  DEFAULT ('0000-00-00') FOR [NgayNhamChuc]
GO
ALTER TABLE [dbo].[chucvu] ADD  DEFAULT ('0000-00-00') FOR [NgayMienNhiem]
GO
ALTER TABLE [dbo].[giaovien] ADD  DEFAULT ('0000-00-00') FOR [NgayVaoLam]
GO
ALTER TABLE [dbo].[gop_y] ADD  DEFAULT ('0000-00-00') FOR [NgayGopY]
GO
ALTER TABLE [dbo].[hocky] ADD  DEFAULT ('0000-00-00') FOR [NgayBatDau]
GO
ALTER TABLE [dbo].[hocky] ADD  DEFAULT ('0000-00-00') FOR [NgayKetThuc]
GO
ALTER TABLE [dbo].[nienkhoa] ADD  DEFAULT ('0000-00-00') FOR [ThoiGianBatDau]
GO
ALTER TABLE [dbo].[nienkhoa] ADD  DEFAULT ('0000-00-00') FOR [ThoiGianKetThuc]
GO
ALTER TABLE [dbo].[phanquyen] ADD  DEFAULT ('0000-00-00') FOR [NgayTao]
GO
ALTER TABLE [dbo].[bode]  WITH CHECK ADD  CONSTRAINT [FK_bode_giaovien] FOREIGN KEY([MaGiaoVien])
REFERENCES [dbo].[giaovien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[bode] CHECK CONSTRAINT [FK_bode_giaovien]
GO
ALTER TABLE [dbo].[bomon]  WITH CHECK ADD  CONSTRAINT [FK_bomon_giaovien] FOREIGN KEY([TruongBoMon])
REFERENCES [dbo].[giaovien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[bomon] CHECK CONSTRAINT [FK_bomon_giaovien]
GO
ALTER TABLE [dbo].[bomon]  WITH CHECK ADD  CONSTRAINT [FK_bomon_he] FOREIGN KEY([MaHe])
REFERENCES [dbo].[he] ([MaHe])
GO
ALTER TABLE [dbo].[bomon] CHECK CONSTRAINT [FK_bomon_he]
GO
ALTER TABLE [dbo].[cauhoi]  WITH CHECK ADD  CONSTRAINT [FK_cauhoi_bode] FOREIGN KEY([MaBoDe])
REFERENCES [dbo].[bode] ([MaBoDe])
GO
ALTER TABLE [dbo].[cauhoi] CHECK CONSTRAINT [FK_cauhoi_bode]
GO
ALTER TABLE [dbo].[cauhoi]  WITH CHECK ADD  CONSTRAINT [FK_cauhoi_bomon] FOREIGN KEY([MaBoMon])
REFERENCES [dbo].[bomon] ([MaBoMon])
GO
ALTER TABLE [dbo].[cauhoi] CHECK CONSTRAINT [FK_cauhoi_bomon]
GO
ALTER TABLE [dbo].[cauhoi]  WITH CHECK ADD  CONSTRAINT [FK_cauhoi_giaovien] FOREIGN KEY([MaGiaoVien])
REFERENCES [dbo].[giaovien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[cauhoi] CHECK CONSTRAINT [FK_cauhoi_giaovien]
GO
ALTER TABLE [dbo].[cauhoi_hocky]  WITH CHECK ADD  CONSTRAINT [FK_cauhoi_hocky_cauhoi] FOREIGN KEY([MaCauHoi])
REFERENCES [dbo].[cauhoi] ([MaCauHoi])
GO
ALTER TABLE [dbo].[cauhoi_hocky] CHECK CONSTRAINT [FK_cauhoi_hocky_cauhoi]
GO
ALTER TABLE [dbo].[cauhoi_hocky]  WITH CHECK ADD  CONSTRAINT [FK_cauhoi_hocky_hocky] FOREIGN KEY([MaHocKy])
REFERENCES [dbo].[hocky] ([MaHocKy])
GO
ALTER TABLE [dbo].[cauhoi_hocky] CHECK CONSTRAINT [FK_cauhoi_hocky_hocky]
GO
ALTER TABLE [dbo].[giaovien]  WITH CHECK ADD  CONSTRAINT [FK_giaovien_bomon] FOREIGN KEY([MaBoMon])
REFERENCES [dbo].[bomon] ([MaBoMon])
GO
ALTER TABLE [dbo].[giaovien] CHECK CONSTRAINT [FK_giaovien_bomon]
GO
ALTER TABLE [dbo].[giaovien]  WITH CHECK ADD  CONSTRAINT [FK_giaovien_chucvu] FOREIGN KEY([MaChucVu])
REFERENCES [dbo].[chucvu] ([MaChucVu])
GO
ALTER TABLE [dbo].[giaovien] CHECK CONSTRAINT [FK_giaovien_chucvu]
GO
ALTER TABLE [dbo].[giaovien]  WITH CHECK ADD  CONSTRAINT [FK_giaovien_giaovien] FOREIGN KEY([GiaoVienQuanLy])
REFERENCES [dbo].[giaovien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[giaovien] CHECK CONSTRAINT [FK_giaovien_giaovien]
GO
ALTER TABLE [dbo].[gop_y]  WITH CHECK ADD  CONSTRAINT [FK_gop_y_cauhoi] FOREIGN KEY([MaCauHoi])
REFERENCES [dbo].[cauhoi] ([MaCauHoi])
GO
ALTER TABLE [dbo].[gop_y] CHECK CONSTRAINT [FK_gop_y_cauhoi]
GO
ALTER TABLE [dbo].[gop_y]  WITH CHECK ADD  CONSTRAINT [FK_gop_y_giaovien] FOREIGN KEY([MaGiaoVien])
REFERENCES [dbo].[giaovien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[gop_y] CHECK CONSTRAINT [FK_gop_y_giaovien]
GO
ALTER TABLE [dbo].[hocky]  WITH CHECK ADD  CONSTRAINT [FK_hocky_nienkhoa] FOREIGN KEY([MaNienKhoa])
REFERENCES [dbo].[nienkhoa] ([MaNienKhoa])
GO
ALTER TABLE [dbo].[hocky] CHECK CONSTRAINT [FK_hocky_nienkhoa]
GO
ALTER TABLE [dbo].[phanquyen_giaovien]  WITH CHECK ADD  CONSTRAINT [FK_phanquyen_giaovien_giaovien] FOREIGN KEY([MaGiaoVien])
REFERENCES [dbo].[giaovien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[phanquyen_giaovien] CHECK CONSTRAINT [FK_phanquyen_giaovien_giaovien]
GO
ALTER TABLE [dbo].[phanquyen_giaovien]  WITH CHECK ADD  CONSTRAINT [FK_phanquyen_giaovien_phanquyen] FOREIGN KEY([MaPhanQuyen])
REFERENCES [dbo].[phanquyen] ([MaPhanQuyen])
GO
ALTER TABLE [dbo].[phanquyen_giaovien] CHECK CONSTRAINT [FK_phanquyen_giaovien_phanquyen]
GO
ALTER TABLE [dbo].[traloi]  WITH CHECK ADD  CONSTRAINT [FK_traloi_cauhoi] FOREIGN KEY([MaCauHoi])
REFERENCES [dbo].[cauhoi] ([MaCauHoi])
GO
ALTER TABLE [dbo].[traloi] CHECK CONSTRAINT [FK_traloi_cauhoi]
GO
