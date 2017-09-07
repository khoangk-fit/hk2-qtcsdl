GO
USE [WWSGO]
GO
DECLARE 	@Quyen_XemCauHoi int,
			@Quyen_ThemCauHoi int,
			@Quyen_XoaCauHoi int,
			@Quyen_CapNhatCauHoi int,
			@Quyen_TaoBoDe int,
			@Quyen_ThemMonHoc int,
			@Quyen_GopY int,
			@Quyen_ThemTaiKhoan int,
			@Quyen_XoaTaiKhoan int,
			@Quyen_SuaTaiKhoan int,
			@Quyen_KhoaTaiKhoan int,
			@Quyen_CapQuanLy int,
			@Quyen_ChucVu int,
			@Quyen_NienKhoa int,
SET		@Quyen_XemCauHoi = 1, @Quyen_ThemCauHoi = 2, @Quyen_XoaCauHoi = 3,
			@Quyen_CapNhatCauHoi = 4, @Quyen_TaoBoDe = 5, @Quyen_ThemMonHoc = 6,
			@Quyen_GopY = 7, @Quyen_ThemTaiKhoan = 8, @Quyen_XoaTaiKhoan = 9
			@Quyen_SuaTaiKhoan = 10, @Quyen_KhoaTaiKhoan = 11, @Quyen_CapQuanLy = 12, @Quyen_ChucVu = 13, @Quyen_NienKhoa = 14
/*
*** Proc He ***
1 - Select			Exec sp_selectHe
2 - Insert			Exec sp_InsertHe 'Hoan Chinh', '1/12/2019'
3 - Edit			Exec sp_UpdateHe 1, '', '10/20/2019'
4 - Delete			Exec sp_DeleteHe 3
*/
CREATE PROC sp_SelectHe
AS
	BEGIN
		SELECT * FROM he 
	END
GO

CREATE PROC sp_InsertHe (@TenHe varchar(255), @NgayTao date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemMonHoc ))
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		Insert into he values(@TenHe, @NgayTao)
		Print N'Thêm thành công Hệ ! ' + @TenHe
	END
GO

CREATE PROC sp_UpdateHe (@MaHe int,@TenHe varchar(255), @NgayTao date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemMonHoc ))
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from he where MaHe = @MaHe))
			BEGIN
				UPDATE he
				SET TenHe = @TenHe,
					NgayTao = @NgayTao
				WHERE MaHe = @MaHe
				Print N'Cập nhật thành công Hệ !'
				Print @MaHe
			END
		ELSE
			BEGIN
				Print N'Không tồn tại Hệ !'
				Print @MaHe
			END
	END
GO

CREATE PROC sp_DeleteHe (@MaHe int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemMonHoc ))
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from bomon where MaHe = @MaHe))
			BEGIN
				Print N'Xóa thất bại hệ!'
				Print @MaHe
				Print N'Hệ này đang được sử dụng ở bộ môn'
			END
		ELSE 
			IF (EXISTS (select * from he where MaHe = @MaHe))
				BEGIN
					DELETE he WHERE MaHe = @MaHe
					Print N'Xóa thành công Hệ !'
					Print @MaHe
				END
			ELSE
				BEGIN
					Print N'Không tồn tại Hệ !'
					Print @MaHe
				END
	END
GO

Exec sp_InsertHe N'Hoan Chinh Dai Hoc', '06/12/2016'
Exec sp_InsertHe N'Dai Hoc Chinh Quy', '06/12/2016'
Exec sp_InsertHe N'Dai Hoc Dao Tao Tu Xa', '06/12/2016'

GO

/*
*** Proc ChucVu ***
1 - Select			Exec sp_selectChucVu
2 - Insert			Exec sp_InsertChucVu 'Giao Vien', '', ''
3 - Edit			Exec sp_UpdateChucVu 8, '', '', ''
4 - Delete			Exec sp_DeleteHe 4
*/
CREATE PROC sp_SelectChucVu
AS
	BEGIN
		SELECT * FROM chucvu
	END
GO

CREATE PROC sp_InsertChucVu (@TenCV varchar(255), @NgayNhanChuc date, @NgayMienNhiem date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@NgayNhanChuc = '')
			BEGIN
				set @NgayNhanChuc = GETDATE();
			END
		IF (@NgayMienNhiem = '')
			BEGIN
				set @NgayMienNhiem = dateadd(day,365,@NgayNhanChuc)
			END
		IF (CONVERT(date, @NgayNhanChuc) <= CONVERT(date, @NgayMienNhiem))
			BEGIN
				Insert into chucvu(TenChucVu, NgayNhamChuc, NgayMienNhiem) values(@TenCV, @NgayNhanChuc, @NgayMienNhiem)
				Print N'Thêm thành công chức vụ! ' + @TenCV
			END
		ELSE
			BEGIN
				PRINT N'Thêm thât bại chức vụ! ' + @TenCV
				PRINT N'Ngay Miễn nhiệm >= ngày nhậm chức'
			END
	END
GO

CREATE PROC sp_UpdateChucVu (@MaCV int,@TenCV varchar(255), @NgayNhanChuc date, @NgayMienNhiem date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from chucvu where MaChucVu = @MaCV))
			BEGIN
				IF (@NgayMienNhiem = '')
					BEGIN
						set @NgayMienNhiem = dateadd(day,365,@NgayNhanChuc)
					END
				IF (CONVERT(date, @NgayNhanChuc) <= CONVERT(date, @NgayMienNhiem))
					BEGIN
						UPDATE chucvu
						SET TenChucVu = @TenCV,
							NgayNhamChuc = @NgayNhanChuc,
							NgayMienNhiem = @NgayMienNhiem
						WHERE MaChucVu = @MaCV
						Print N'Cập nhật thành công Chức vụ! '
						Print @MaCV
					END
				ELSE
					BEGIN
						PRINT N'Cập nhật thât bại chức vụ! ' + @TenCV
						PRINT N'Ngay Miễn nhiệm >= ngày nhậm chức'
					END
			END
		ELSE
			BEGIN
				Print N'Không tồn tại Chức vụ!'
				Print @MaCV
			END
	END
GO

CREATE PROC sp_DeleteChucVu (@MaCV int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from giaovien where MaChucVu = @MaCV))
			BEGIN
				Print N'Xóa thất bại chức vụ!'
				Print @MaCV
				Print N'Chức vụ này đang được sử dụng'
				RETURN 1
			END
		IF (EXISTS (select * from chucvu where MaChucVu = @MaCV))
			BEGIN
				DELETE chucvu WHERE MaChucVu = @MaCV
				Print N'Xóa thành công Chức vụ!'
				Print @MaCV
			END
		ELSE
			BEGIN
				Print N'Không tồn tại Chức vụ!'
				Print @MaCV
			END
	END
GO

Exec sp_InsertChucVu 'Giao vien', '07/12/2017', ''
Exec sp_InsertChucVu 'Quan ly', '07/12/2017', ''
Exec sp_InsertChucVu 'Quan tri', '07/12/2017', ''

GO

/*
*** Proc bomon ***
1 - Select			Exec sp_SelectBoMon
2 - Insert			Exec sp_InsertBoMon 1, 'Hoan Chinh', '1/12/2019', ''
3 - Edit			Exec sp_UpdateBoMon 6, 2, '', '', 0
4 - Delete			Exec sp_DeleteBoMon 5
*/

CREATE PROC sp_SelectBoMon
AS
	BEGIN
		SELECT * FROM bomon
	END
GO

CREATE PROC sp_InsertBoMon (@MaHe int, @TenBoMon varchar(255),
						 @NgayTao date, @TruongBoMon int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemMonHoc ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		IF	(EXISTS (select * from he where MaHe = @MaHe))
			BEGIN
				IF(EXISTS (select * from giaovien where MaGiaoVien = @TruongBoMon))
					BEGIN 
						Insert into bomon(MaHe, TenBoMon, NgayTao, TruongBoMon) values(@MaHe, @TenBoMon, @NgayTao, @TruongBoMon)
						Print N'Thêm thành công bộ môn ! ' + @TenBoMon
					END
				ELSE
					IF(@TruongBoMon = '')
						BEGIN
							Insert into bomon(MaHe, TenBoMon, NgayTao) values(@MaHe, @TenBoMon, @NgayTao)
							Print N'Thêm thành công bộ môn ! ' + @TenBoMon
						END
					ELSE
						BEGIN
							Print N'Thêm thất bại bộ môn! ' + @TenBoMon
							Print N'Mã giáo viên này không tồn tại! '
						END
			END
		ELSE
			BEGIN
				Print N'Thêm thất bại bộ môn! ' + @TenBoMon
				Print N'Mã hệ này không tồn tại! '
			END
	END
GO

CREATE PROC sp_UpdateBoMon (@MaBM int,@MaHe int, @TenBoMon varchar(255),
						 @NgayTao date, @TruongBoMon int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemMonHoc ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from bomon where MaBoMon = @MaBM))
			BEGIN
				IF	(EXISTS (select * from he where MaHe = @MaHe))
					BEGIN
						IF(EXISTS (select * from giaovien where MaGiaoVien = @TruongBoMon))
							BEGIN
								UPDATE bomon
								SET MaHe = @MaHe,
									TenBoMon = @TenBoMon,
									NgayTao = @NgayTao,
									TruongBoMon = @TruongBoMon
								WHERE MaBoMon = @MaBM
								Print N'Cập nhật thành công Bộ môn! '
								Print @MaBM
							END
						ELSE
							IF(@TruongBoMon = '')
								BEGIN
									UPDATE bomon
									SET MaHe = @MaHe,
										TenBoMon = @TenBoMon,
										NgayTao = @NgayTao
									WHERE MaBoMon = @MaBM
									Print N'Cập nhật thành công bộ môn! '
									Print @MaBM
								END
							ELSE
								BEGIN
									Print N'Cập nhật thất bại bộ môn! '
									Print @MaBM
									Print N'Giáo viên này không tồn tại! '
								END
					END
				ELSE
					BEGIN
						PRINT N'Cập nhật thât bại bộ môn! ' 
						Print @MaBM
						Print N'Hệ này không tồn tại! '

					END
			END
		ELSE
			BEGIN
				Print N'Không tồn tại bộ môn!'
				Print @MaBM
			END
	END
GO

CREATE PROC sp_DeleteBoMon (@MaBM int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemMonHoc ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from giaovien where MaBoMon = @MaBM))
			BEGIN
				Print N'Xóa thất bại bộ môn!'
				Print @MaBM
				Print N'Bộ môn này đang được sử dụng'
				RETURN 1
			END
		IF (EXISTS (select * from bomon where MaBoMon = @MaBM))
			BEGIN
				DELETE bomon WHERE MaBoMon = @MaBM
				Print N'Xóa thành công bộ môn!'
				Print @MaBM
			END
		ELSE
			BEGIN
				Print N'Không tồn tại bộ môn!'
				Print @MaBM
			END
	END
GO

Exec sp_InsertBoMon 1, 'HQTCSDL', '', ''
Exec sp_InsertBoMon 2, 'KTDL-UD', '', ''
Exec sp_InsertBoMon 3, 'JAVA', '', ''
Exec sp_InsertBoMon 1, 'MANG MAY TINH', '', ''
Exec sp_InsertBoMon 2, 'TOAN B1', '', ''
Exec sp_InsertBoMon 3, 'ANH VAN 2', '', ''

GO

/*
*** Proc Phanquyen ***
1 - Select			Exec sp_selectPhanQuyen
2 - Insert			Exec sp_InsertPhanQuyen 'Hoan Chinh', '1/12/2019'
3 - Edit			Exec sp_UpdatePhanQuyen 13, 'Hoan chinh', '10/20/2019'
4 - Delete			Exec sp_DeletePhanQuyen 3
*/
CREATE PROC sp_selectPhanQuyen
AS
	BEGIN
		SELECT * FROM phanquyen 
	END
GO

CREATE PROC sp_InsertPhanQuyen (@TenPQ varchar(255), @NgayTao date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		Insert into phanquyen(TenPhanQuyen, NgayTao) values(@TenPQ, @NgayTao)
		Print N'Thêm thành công quyền ! ' + @TenPQ
	END
GO

CREATE PROC sp_UpdatePhanQuyen (@MaPQ int,@TenPQ varchar(255), @NgayTao date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from phanquyen where MaPhanQuyen = @MaPQ))
			BEGIN
				UPDATE phanquyen
				SET TenPhanQuyen = @TenPQ,
					NgayTao = @NgayTao
				WHERE MaPhanQuyen = @MaPQ
				Print N'Cập nhật thành công phân quyền !'
				Print @MaPQ
			END
		ELSE 
			BEGIN
				Print N'Không tồn tại phân quyền !'
				Print @MaPQ
			END
	END
GO

CREATE PROC sp_DeletePhanQuyen (@MaPQ int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from phanquyen_giaovien where MaPhanQuyen = @MaPQ))
			BEGIN
				Print N'Xóa thất bại phân quyền!'
				Print @MaPQ
				Print N'Phân quyền này đang được sử dụng!'
			END
		ELSE 
			IF (EXISTS (select * from phanquyen where MaPhanQuyen = @MaPQ))
				BEGIN
					DELETE phanquyen WHERE MaPhanQuyen = @MaPQ
					Print N'Xóa thành công phân quyền!'
					Print @MaPQ
				END
			ELSE
				BEGIN
					Print N'Không tồn tại phân quyền !'
					Print @MaPQ
				END
	END
GO

Exec sp_InsertPhanQuyen 'Xem Cau Hoi', ''
Exec sp_InsertPhanQuyen 'Them Cau Hoi', ''
Exec sp_InsertPhanQuyen 'Xoa Cau Hoi', ''
Exec sp_InsertPhanQuyen 'Cap nhat Cau Hoi', ''
Exec sp_InsertPhanQuyen 'Tao bo de thi trac nghiem Cau Hoi', ''
Exec sp_InsertPhanQuyen 'Them Mon Hoc', ''
Exec sp_InsertPhanQuyen 'Gop Y cau hoi trac nghiem', ''
Exec sp_InsertPhanQuyen 'Them Tai Khoan', ''
Exec sp_InsertPhanQuyen 'Xoa Tai Khoan', ''
Exec sp_InsertPhanQuyen 'Sua Tai Khoan', ''
Exec sp_InsertPhanQuyen 'Khoa Tai Khoan', ''
Exec sp_InsertPhanQuyen 'Cap quyen quan ly', ''

/*
*** Proc GIAOVIEN ***
1 - Select			Exec sp_selectGiaoVien
2 - Insert			Exec sp_InsertGiaoVien 1,1,'Minh 1','01/11/1993',1,'01/11/2003','',1,'cmnd1'
3 - Edit			Exec sp_UpdateGiaoVien 6,3,2,'Minh Thuy','01/11/1993',1,'01/11/2003',2,1,'cmnd100'
4 - Delete			Exec sp_DeleteGiaoVien 10
*/

GO 
CREATE PROC sp_selectGiaoVien
AS
	BEGIN
		SELECT * FROM giaovien 
	END
GO


CREATE PROC sp_InsertGiaoVien(@MaCV int, @MaBM int, @TenGV varchar(255), @Ngaysinh date, @GioiTinh BIT,
								@Ngayvaolam date, @GVQL int, @TrangThai BIT, @cmnd varchar(20), @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemTaiKhoan ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@MaCV = '')
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Mã chức vụ không được rỗng'
				RETURN 0
			END
		IF(@TenGV = '')
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Tên giáo viên không được rỗng'
				RETURN 1
			END
		IF(@Ngaysinh = '')
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Ngày sinh không được rỗng'
				RETURN 1
			END
		IF (@cmnd = '')
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Chứng minh nhân dân không được rỗng'
				RETURN 1
			END
		
		DECLARE @TUOILD DATE
		DECLARE @TUOI INT
		--TỐI THIÊU PHẢI TỪ 10 TUỔI TRỞ LÊN -- 
		SET @TUOI = 10 
		SET @TUOILD = dateadd(day,(@TUOI*365),@Ngaysinh)
		IF (@Ngayvaolam = '')
			BEGIN
				SET @Ngayvaolam = GETDATE()
			END
		IF( (EXISTS (select * from giaovien where cmnd = @cmnd)))
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Chướng minh nhân dân không được trùng!'
				RETURN 1
			END
		IF( (EXISTS (select * from chucvu where MaChucVu = @MaCV)) AND
			(CONVERT(date, @Ngayvaolam) >= CONVERT(date, @TUOILD)) )
			BEGIN
				IF(@MaBM ='')
					BEGIN
						IF(@GVQL = '')
								BEGIN
									INSERT INTO giaovien(MaChucVu, TenGiaoVien, NgaySinh, GioiTinh, NgayVaoLam,
														TrangThai, cmnd)
									VALUES (@MaCV, @TenGV, @Ngaysinh, @GioiTinh, @Ngayvaolam, @TrangThai, @cmnd)
									Print N'Thêm thành công giáo viên! ' + @TenGV
								END
							ELSE 
								IF (EXISTS (select * from giaovien where MaGiaoVien = @GVQL))
									BEGIN
										INSERT INTO giaovien(MaChucVu, TenGiaoVien, NgaySinh, GioiTinh, NgayVaoLam,
													GiaoVienQuanLy,TrangThai, cmnd)
										VALUES (@MaCV, @TenGV, @Ngaysinh, @GioiTinh, @Ngayvaolam, @GVQL, @TrangThai, @cmnd)
										Print N'Thêm thành công giáo viên! ' + @TenGV
									END
								ELSE
									BEGIN
										PRINT N'Thêm thất bại giáo viên! ' + @TenGV
										PRINT N'Mã giáo viên quản lý không tồn tại!'
										RETURN 1
									END
					END
				ELSE
					IF( (EXISTS (select * from bomon where MaBoMon = @MaBM)) )
						BEGIN
							IF(@GVQL = '')
								BEGIN
									INSERT INTO giaovien(MaChucVu, MaBoMon, TenGiaoVien, NgaySinh, GioiTinh, NgayVaoLam,
														TrangThai, cmnd)
									VALUES (@MaCV, @MaBM, @TenGV, @Ngaysinh, @GioiTinh, @Ngayvaolam, @TrangThai, @cmnd)
									Print N'Thêm thành công giáo viên! ' + @TenGV
								END
							ELSE 
								IF (EXISTS (select * from giaovien where MaGiaoVien = @GVQL))
									BEGIN
										INSERT INTO giaovien(MaChucVu, MaBoMon, TenGiaoVien, NgaySinh, GioiTinh, NgayVaoLam,
													GiaoVienQuanLy,TrangThai, cmnd)
										VALUES (@MaCV, @MaBM, @TenGV, @Ngaysinh, @GioiTinh, @Ngayvaolam, @GVQL, @TrangThai, @cmnd)
										Print N'Thêm thành công giáo viên! ' + @TenGV
									END
								ELSE
									BEGIN
										PRINT N'Thêm thất bại giáo viên! ' + @TenGV
										PRINT N'Mã giáo viên quản lý không tồn tại!'
										RETURN 1
									END
						END
					ELSE
						BEGIN
							PRINT N'Thêm thất bại giáo viên! ' + @TenGV
							PRINT N'Mã bộ môn không tồn tại!'
						END
			END
		ELSE
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Mã chức vụ không tồn tại! hay'
				PRINT N'Ngày vào làm phải lơn hơn tuổi lao động !'
				RETURN 1
			END
	END
GO


CREATE PROC sp_UpdateGiaoVien(@MaGV int, @MaCV int, @MaBM int, @TenGV varchar(255), @Ngaysinh date, @GioiTinh BIT,
								@Ngayvaolam date, @GVQL int, @TrangThai BIT, @cmnd varchar(20), @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_SuaTaiKhoan ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF( NOT EXISTS (select * from giaovien where MaGiaoVien = @MaGV) )
			BEGIN
				Print N'Không tồn tại giáo viên!'
				Print @MaGV
				RETURN 0
			END
		IF(@MaCV = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @TenGV
				PRINT N'Mã chức vụ không được rỗng'
				RETURN 0
			END
		IF(@TenGV = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @TenGV
				PRINT N'Tên giáo viên không được rỗng'
				RETURN 1
			END
		IF(@Ngaysinh = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @TenGV
				PRINT N'Ngày sinh không được rỗng'
				RETURN 1
			END
		IF (@cmnd = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @TenGV
				PRINT N'Chứng minh nhân dân không được rỗng'
				RETURN 1
			END
		
		DECLARE @TUOILD DATE
		DECLARE @TUOI INT
		--TỐI THIÊU PHẢI TỪ 10 TUỔI TRỞ LÊN -- 
		SET @TUOI = 10 
		SET @TUOILD = dateadd(day,(@TUOI*365),@Ngaysinh)
		IF (@Ngayvaolam = '')
			BEGIN
				SET @Ngayvaolam = GETDATE()
			END
		IF( (EXISTS (select * from giaovien where cmnd = @cmnd)))
			BEGIN
				PRINT N'Thêm thất bại giáo viên! ' + @TenGV
				PRINT N'Chướng minh nhân dân không được trùng!'
				RETURN 1
			END
		IF( (EXISTS (select * from chucvu where MaChucVu = @MaCV)) AND
			(CONVERT(date, @Ngayvaolam) >= CONVERT(date, @TUOILD)) )
			BEGIN
				IF(@MaBM ='')
					BEGIN
						IF(@GVQL = '')
							BEGIN
								UPDATE giaovien
								SET MaChucVu = @MaCV,
									TenGiaoVien = @TenGV,
									MaBoMon = 0,
									NgaySinh = @Ngaysinh,
									GioiTinh = @GioiTinh,
									NgayVaoLam = @Ngayvaolam,
									TrangThai = @TrangThai,
									cmnd = @cmnd			
								WHERE MaGiaoVien = @MaGV	
								Print N'Cập nhật thành công giáo viên !'
								Print @MaGV	
								RETURN 1				
							END
						ELSE 
							IF (EXISTS (select * from giaovien where MaGiaoVien = @GVQL))
								BEGIN
									UPDATE giaovien
									SET MaChucVu = @MaCV,
										MaBoMon = 0,
										TenGiaoVien = @TenGV,
										NgaySinh = @Ngaysinh,
										GioiTinh = @GioiTinh,
										NgayVaoLam = @Ngayvaolam,
										GiaoVienQuanLy = @GVQL,
										TrangThai = @TrangThai,
										cmnd = @cmnd			
									WHERE MaGiaoVien = @MaGV	
									Print N'Cập nhật thành công giáo viên !'
									Print @MaGV	
								END
							ELSE
								BEGIN
									PRINT N'Cập nhật thất bại giáo viên! ' 
									Print @MaGV
									PRINT N'Mã giáo viên quản lý không tồn tại!'
									RETURN 1
								END
					END
				ELSE
					IF( (EXISTS (select * from bomon where MaBoMon = @MaBM)) )
						BEGIN
							IF(@GVQL = '')
								BEGIN
									UPDATE giaovien
									SET MaChucVu = @MaCV,
										MaBoMon = @MaBM,
										TenGiaoVien = @TenGV,
										NgaySinh = @Ngaysinh,
										GioiTinh = @GioiTinh,
										NgayVaoLam = @Ngayvaolam,
										GiaoVienQuanLy = '',
										TrangThai = @TrangThai,
										cmnd = @cmnd			
									WHERE MaGiaoVien = @MaGV	
									Print N'Cập nhật thành công giáo viên !'
									Print @MaGV	
									RETURN 1
								END
							ELSE 
								IF (EXISTS (select * from giaovien where MaGiaoVien = @GVQL))
									BEGIN
										UPDATE giaovien
										SET MaChucVu = @MaCV,
											MaBoMon = @MaBM,
											TenGiaoVien = @TenGV,
											NgaySinh = @Ngaysinh,
											GioiTinh = @GioiTinh,
											NgayVaoLam = @Ngayvaolam,
											GiaoVienQuanLy = @GVQL,
											TrangThai = @TrangThai,
											cmnd = @cmnd			
										WHERE MaGiaoVien = @MaGV	
										Print N'Cập nhật thành công giáo viên !'
										Print @MaGV	
										RETURN 1
									END
								ELSE
									BEGIN
										PRINT N'Cập nhật thất bại giáo viên! ' 
										Print @MaGV
										PRINT N'Mã giáo viên quản lý không tồn tại!'
										RETURN 1
									END
						END
					ELSE
						BEGIN
							PRINT N'Thêm thất bại giáo viên! '
							Print @MaGV
							PRINT N'Mã bộ môn không tồn tại!'
							return 1
						END
			END
		ELSE
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! '
					Print @MaGV
				PRINT N'Mã chức vụ không tồn tại! hay'
				PRINT N'Ngày vào làm phải lơn hơn tuổi lao động !'
				RETURN 1
			END
	END
GO

CREATE PROC sp_DeleteGiaoVien (@MaGV int, @MaGVCV)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_XoaTaiKhoan ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (	EXISTS (select * from phanquyen_giaovien where MaGiaoVien = @MaGV) OR
				EXISTS (select * from cauhoi where MaGiaoVien = @MaGV) )
			BEGIN
				Print N'Xóa thất bại giao viên!'
				Print @MaGV
				Print N'Giáo viên này đang được sử dụng!'
				RETURN 1
			END
		IF (EXISTS (select * from giaovien where MaGiaoVien = @MaGV))
			BEGIN
				DELETE giaovien WHERE MaGiaoVien = @MaGV
				Print N'Xóa thành công giáo viên!'
				Print @MaGV
			END
		ELSE
			BEGIN
				Print N'Không tồn tại giáo viên!'
				Print @MaGV
			END
	END
GO

Exec sp_InsertGiaoVien 1,1,'Minh 1','01/11/1993',1,'01/11/2003','',1,'cmnd1'
Exec sp_InsertGiaoVien 1,1,'Minh 2','01/11/1993',1,'01/11/2003','',1,'cmnd2'
Exec sp_InsertGiaoVien 1,2,'Thuy 1','01/11/1993',0,'01/11/2003','',1,'cmnd3'
Exec sp_InsertGiaoVien 1,2,'Minh 3','01/11/1993',1,'01/11/2003','',1,'cmnd4'
Exec sp_InsertGiaoVien 1,2,'Thuy 2','01/11/1993',0,'01/11/2003','',1,'cmnd5'
Exec sp_InsertGiaoVien 2,3,'Thuy 3','01/11/1993',0,'01/11/2004','',1,'cmnd6'
Exec sp_InsertGiaoVien 2,3,'Minh 4','01/11/1993',1,'01/11/2005','',1,'cmnd7'
Exec sp_InsertGiaoVien 2,4,'Thuy 4','01/11/1993',0,'01/11/2006','',1,'cmnd8'
Exec sp_InsertGiaoVien 3,5,'Minh 5','01/11/1993',1,'01/11/2007','',1,'cmnd9'
Exec sp_InsertGiaoVien 3,'','Minh Thuy','01/11/1993',1,'01/11/2003','',1,'cmnd10'

GO

/*
*** Proc PHANQUYEN_GIAOVIEN ***
1 - Select			Exec sp_selectPQGV
2 - Insert			EXEC sp_InsertPQGV '11', '2'
3 - Edit			exec sp_UpdatePQGV 4,8,12
4 - Delete			exec sp_DeletePQGV 4,10
*/

GO 
CREATE PROC sp_selectPQGV
AS
	BEGIN
		SELECT * FROM phanquyen_giaovien 
	END
GO

CREATE PROC sp_InsertPQGV(@MaGV int, @MaPQ int, @MaGVCV)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@MaPQ = '')
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã phân quyền không được rỗng'
				RETURN 0
			END
		IF (@MaGV = '')
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã giáo viên không được rỗng'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from phanquyen where MaPhanQuyen = @MaPQ) )
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã Phân quyền không tồn tại'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from giaovien where MaGiaoVien = @MaGV) )
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã giáo viên không tồn tại'
				RETURN 0
			END
		IF ( EXISTS (select * from phanquyen_giaovien where MaPhanQuyen = @MaPQ) AND
			 EXISTS (select * from phanquyen_giaovien where MaGiaoVien = @MaGV) )
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã phân quyền cho giáo viên này đã được thêm'
				RETURN 0
			END
		INSERT INTO phanquyen_giaovien(MaGiaoVien, MaPhanQuyen)
		VALUES (@MaGV, @MaPQ)
	END
GO

CREATE PROC sp_UpdatePQGV(@MaGV int,@MaPQ int,@MaPQnew int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@MaPQ = '')
			BEGIN
				PRINT N'Cập nhật thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã phân quyền không được rỗng'
				RETURN 0
			END
		IF (@MaGV = '')
			BEGIN
				PRINT N'Cập nhật thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã giáo viên không được rỗng'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaPhanQuyen = @MaPQ) OR 
			 NOT EXISTS (select * from phanquyen where MaPhanQuyen = @MaPQnew)	 )
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã Phân quyền không tồn tại'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGiaoVien = @MaGV) )
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'Mã giáo viên không tồn tại'
				RETURN 0
			END
		IF ( (EXISTS (select * from phanquyen_giaovien where MaGiaoVien = @MaGV AND MaPhanQuyen = @MaPQ )) AND
			 (EXISTS (select * from phanquyen_giaovien where MaGiaoVien = @MaGV AND MaPhanQuyen = @MaPQnew )) )
			BEGIN
				PRINT N'Thêm thất bại phân quyền giáo viên! '
				PRINT @MaPQ
				PRINT N'phân quyền giáo viên đã tồn tại'
				RETURN 0
			END
		ELSE
			BEGIN
				UPDATE phanquyen_giaovien
				SET MaPhanQuyen = @MaPQnew
				WHERE MaGiaoVien = @MaGV AND MaPhanQuyen = @MaPQ
			END
	END
GO

CREATE PROC sp_DeletePQGV(@MaGV int,@MaPQ int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ChucVu ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(EXISTS (select * from phanquyen_giaovien where MaGiaoVien = @MaGV AND MaPhanQuyen = @MaPQ ))
			BEGIN
				DELETE phanquyen_giaovien WHERE MaGiaoVien = @MaGV AND MaPhanQuyen = @MaPQ
				Print N'Xóa thành công phân quyền giáo viên!'
				Print @MaGV
			END
		ELSE 
			BEGIN
				PRINT N'Xóa thất bại phân quyền giáo viên không tồn tại! '
			END
	END

EXEC sp_InsertPQGV '8', '4'



EXEC sp_selectPhanQuyen
exec sp_selectPQGV

/*
*** Proc CAUHOI ***
1 - Select			Exec sp_selectCauHoi
2 - Insert			EXEC sp_InsertCauHoi 1,'','1','ABC la gi ?','1',1,1,'',1,''
3 - Edit			EXEC sp_UpdateCauHoi 1,'1','2','1','ABC','0.23','1','','','',''
4 - Delete			Exec sp_DeleteCauHoi 1
*/

GO 
CREATE PROC sp_selectCauHoi
AS
	BEGIN
		SELECT * FROM cauhoi 
	END
GO

CREATE PROC sp_InsertCauHoi(@MaGV int, @MaBD int, @MaBM int, @NoiDung varchar(255), @ThangDiem float, @MucDo int, @LuaChon BIT, @Ngaytao date,
								  @TrangThai BIT, @Thutu int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemCauHoi ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Nội dung không được rỗng'
				RETURN 0
			END
		IF(@MaGV = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mã Giáo viên không được rỗng'
				RETURN 0
			END
		IF(@MaBM = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mã bộ môn không được rỗng'
				RETURN 0
			END
		IF(@ThangDiem = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Thang điểm không được rỗng'
				RETURN 0
			END
		IF(@MucDo = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mức độ câu hỏi không được rỗng'
				RETURN 0
			END
		IF(@Ngaytao = '')
			BEGIN
				set @Ngaytao = GETDATE()
			END
		IF (@MucDo != 1 and @MucDo != 2 and @MucDo != 3 )
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mức độ câu hỏi sai định dạng'
				PRINT N'1:khó ; 2:vừa ; 3:dễ'
				RETURN 0
			END
		
		IF( EXISTS (select * from giaovien where MaGiaoVien = @MaGV) AND
			 (EXISTS (select * from bomon where MaBoMon = @MaBM)) )
			BEGIN
				IF (@MaBD = '')
					BEGIN
						INSERT INTO cauhoi(MaGiaoVien, MaBoMon, NoiDung, ThangDiem, MucDo,
												LuaChon, NgayTao, TrangThai, ThuTu)
						VALUES (@MaGV, @MaBM, @NoiDung, @ThangDiem, @MucDo, @LuaChon, @Ngaytao,
								  @TrangThai, @Thutu)
						Print N'Thêm thành công câu hỏi! ' + @NoiDung
						return 1
					END
				ELSE
					IF ( (EXISTS (select * from bode where MaBoDe = @MaBD)) )
						BEGIN
							INSERT INTO cauhoi(MaGiaoVien, MaBoDe, MaBoMon, NoiDung, ThangDiem, MucDo,
												LuaChon, NgayTao, TrangThai, ThuTu)
							VALUES (@MaGV, @MaBD, @MaBM, @NoiDung, @ThangDiem, @MucDo, @LuaChon, @Ngaytao,
									@TrangThai, @Thutu)
							Print N'Thêm thành công câu hỏi! ' + @NoiDung
							return 1
						END
					ELSE
						BEGIN
							PRINT N'Thêm thất bại câu hỏi! ' + @NoiDung
							PRINT N'Mã bộ đề không tồn tại!'
						END
			END
		ELSE
			BEGIN
				PRINT N'Thêm thất bại câu hỏi! ' + @NoiDung
				PRINT N'Mã giáo viên không tồn tại! hay'
				PRINT N'Mã bộ môn không tồn tại !'
				RETURN 1
			END

	END
GO

CREATE PROC sp_UpdateCauHoi(@MaCH int,@MaGV int, @MaBD int, @MaBM int, @NoiDung varchar(255), @ThangDiem float, @MucDo int, @LuaChon BIT, @Ngaytao date,
								  @TrangThai BIT, @Thutu int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_CapNhatCauHoi ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF( NOT EXISTS (select * from cauhoi where MaCauHoi = @MaCH) )
			BEGIN
				Print N'Không tồn tại câu hỏi !'
				Print @MaCH
				RETURN 0
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Nội dung không được rỗng'
				RETURN 0
			END
		IF(@MaGV = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mã Giáo viên không được rỗng'
				RETURN 0
			END
		IF(@MaBM = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mã bộ môn không được rỗng'
				RETURN 0
			END
		IF(@ThangDiem = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Thang điểm không được rỗng'
				RETURN 0
			END
		IF(@MucDo = '')
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mức độ câu hỏi không được rỗng'
				RETURN 0
			END
		IF(@Ngaytao = '')
			BEGIN
				set @Ngaytao = GETDATE()
			END
		IF (@MucDo != 1 and @MucDo != 2 and @MucDo != 3 )
			BEGIN
				PRINT N'Cập nhật thất bại giáo viên! ' + @NoiDung
				PRINT N'Mức độ câu hỏi sai định dạng'
				PRINT N'1:khó ; 2:vừa ; 3:dễ'
				RETURN 0
			END
		IF( EXISTS (select * from giaovien where MaGiaoVien = @MaGV) AND
				(EXISTS (select * from bomon where MaBoMon = @MaBM)) )
				BEGIN
				IF(@MaBD = '')
					BEGIN
						UPDATE cauhoi
						SET MaGiaoVien = @MaGV,
							MaBoMon = @MaBM,
							NoiDung = @NoiDung,
							ThangDiem = @ThangDiem,
							MucDo = @MucDo,
							LuaChon = @LuaChon,
							NgayTao = @Ngaytao,
							TrangThai = @TrangThai,
							ThuTu = @Thutu			
						WHERE MaCauHoi = @MaCH
						Print N'Cập nhật thành công câu hỏi!'
						Print @MaCH	
						RETURN 1
					END
				ELSE
					IF ( (EXISTS (select * from bode where MaBoDe = @MaBD)) )
						BEGIN
							UPDATE cauhoi
							SET MaGiaoVien = @MaGV,
								MaBoDe = @MaBD,
								MaBoMon = @MaBM,
								NoiDung = @NoiDung,
								ThangDiem = @ThangDiem,
								MucDo = @MucDo,
								LuaChon = @LuaChon,
								NgayTao = @Ngaytao,
								TrangThai = @TrangThai,
								ThuTu = @Thutu			
							WHERE MaCauHoi = @MaCH
							Print N'Cập nhật thành công câu hỏi!'
							Print @MaGV	
							RETURN 1
						END
					ELSE
						BEGIN
							PRINT N'Cập nhật thất bại câu hỏi! '
							PRINT @MaCH
							PRINT N'Mã bộ đề không tồn tại!'	
							RETURN 1				
						END
				END
		ELSE
			BEGIN
				PRINT N'Cập nhật thất bại câu hỏi! '
				PRINT @MaCH
				PRINT N'Mã giáo viên không tồn tại! hay'
				PRINT N'Mã bộ môn không tồn tại !'
				RETURN 1
			END
		
	END
GO

CREATE PROC sp_DeleteCauHoi (@MaCH int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_XoaCauHoi ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (	EXISTS (select * from gop_y where MaCauHoi = @MaCH) OR
				EXISTS (select * from cauhoi_hocky where MaCauHoi = @MaCH) OR
				EXISTS (select * from traloi where MaCauHoi = @MaCH) )
			BEGIN
				Print N'Xóa thất bại giao viên!'
				Print @MaCH
				Print N'Giáo viên này đang được sử dụng!'
				RETURN 1
			END
		IF (EXISTS (select * from cauhoi where MaCauHoi = @MaCH))
			BEGIN
				DELETE cauhoi WHERE MaCauHoi = @MaCH
				Print N'Xóa thành công câu hỏi!'
				Print @MaCH
			END
		ELSE
			BEGIN
				Print N'Không tồn tại câu hỏi!'
				Print @MaCH
			END
	END
GO

EXEC sp_InsertCauHoi 1,'','1','ABC la gi ?','1',1,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','DEF la gi ?','2',2,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','GHK la gi ?','3',3,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','QWE la gi ?','0.5',1,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','RTY la gi ?','0.25',2,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','UIO la gi ?','0.25',3,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','PAS la gi ?','1',1,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','DFG la gi ?','2',2,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','HJK la gi ?','3',3,1,'',1,''
EXEC sp_InsertCauHoi 1,'','1','ZXC la gi ?','4',1,1,'',1,''

GO

/*
*** Proc BODE ***
1 - Select			Exec sp_selectBoDe
2 - Insert			EXEC sp_InsertBoDe '1', 'De A', '','10','10',''
3 - Edit			EXEC sp_UpdateBoDe '1','9','abc','','123','1',''
4 - Delete			Exec sp_DeleteBoDe 3
*/

GO 
CREATE PROC sp_selectBoDe
AS
	BEGIN
		SELECT * FROM bode 
	END
GO

CREATE PROC sp_InsertBoDe(@MaGV int, @TenBD varchar(100), @NgayTao date, @NoiDung varchar(max),@ThangDiem int, @ThuTu smallint, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_TaoBoDe ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@MaGV = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! ' + @TenBD
				PRINT N'Mã giáo viên không được rỗng'
				RETURN 0
			END
		IF(@TenBD = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! ' + @TenBD
				PRINT N'Tên bộ đề không được rỗng'
				RETURN 0
			END
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! ' + @TenBD
				PRINT N'Nội dung không được rỗng'
				RETURN 0
			END
		IF(@ThangDiem = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! ' + @NoiDung
				PRINT N'Thang điểm không được rỗng'
				RETURN 0
			END
		IF ( EXISTS (select * from giaovien where MaGiaoVien = @MaGV) )
			BEGIN
				INSERT INTO bode(MaGiaoVien, TenBoDe, NgayTao, NoiDung, ThangDiem, ThuTu)
				VALUES (@MaGV, @TenBD, @NgayTao, @NoiDung, @ThangDiem, @ThuTu)
			END
		ELSE
			BEGIN
				PRINT N'Thêm thất bại bộ đề! ' + @NoiDung
				PRINT N'Mã giáo viên không tồn tại!'
				RETURN 1
			END
	END

GO

CREATE PROC sp_UpdateBoDe(@MaBD int,@MaGV int, @TenBD varchar(100), @NgayTao date, @NoiDung varchar(max),@ThangDiem int, @ThuTu smallint, @MaGVCV)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_TaoBoDe ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF( NOT EXISTS (select * from bode where MaBoDe = @MaBD) )
			BEGIN
				Print N'Không tồn tại bộ đề !'
				Print @MaBD
				RETURN 0
			END
		IF(@MaGV = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! ' 
				PRINT @MaBD
				PRINT N'Mã giáo viên không được rỗng'
				RETURN 0
			END
		IF(@TenBD = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! '
				PRINT @MaBD
				PRINT N'Tên bộ đề không được rỗng'
				RETURN 0
			END
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! '
				PRINT @MaBD
				PRINT N'Nội dung không được rỗng'
				RETURN 0
			END
		IF(@ThangDiem = '')
			BEGIN
				PRINT N'Thêm thất bại Bộ đề! '
				PRINT @MaBD
				PRINT N'Thang điểm không được rỗng'
				RETURN 0
			END
		IF ( EXISTS (select * from giaovien where MaGiaoVien = @MaGV) )
			BEGIN
				UPDATE bode
				SET TenBoDe = @TenBD,
					NgayTao = @NgayTao,
					NoiDung = @NoiDung,
					ThangDiem = @ThangDiem,
					ThuTu = @ThuTu,
					MaGiaoVien = @MaGV
				WHERE MaBoDe = @MaBD
				Print N'Cập nhật thành công bộ đề!'
				Print @MaBD	
				RETURN 1
			END
		ELSE
			BEGIN
				PRINT N'Thêm thất bại bộ đề! ' + @NoiDung
				PRINT N'Mã giáo viên không tồn tại!'
				RETURN 1
			END
	END

GO 
CREATE PROC sp_DeleteBoDe(@MaBD int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_TaoBoDe ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF( NOT EXISTS (select * from bode where MaBoDe = @MaBD) )
			BEGIN
				Print N'Không tồn tại bộ đề !'
				Print @MaBD
				RETURN 0
			END
		IF (	EXISTS (select * from cauhoi where MaBoDe = @MaBD) )
			BEGIN
				Print N'Xóa thất bại bộ đề!'
				Print @MaBD
				Print N'Bộ đề này đang được sử dụng!'
				RETURN 0
			END
		DELETE bode WHERE MaBoDe = @MaBD
		Print N'Xóa thành công bộ đề!'
		Print @MaBD
		RETURN 1
	END
GO

EXEC sp_InsertBoDe '1', 'De A', '','10','10',''
EXEC sp_InsertBoDe '2', 'De B', '','123','100',''
EXEC sp_InsertBoDe '3', 'De C', '','1234','10',''
EXEC sp_InsertBoDe '4', 'De D', '','1235','100',''
EXEC sp_InsertBoDe '5', 'De E', '','1236','10',''
EXEC sp_UpdateBoDe '1','9','abc','','123','1',''

/*
*** Proc GOPY ***
1 - Select			Exec sp_selectGopY
2 - Insert			Exec sp_InsertGopY '3', '3', 'abc', ''
3 - Edit			Exec sp_UpdateGopY '1','1','2','ab',''
4 - Delete			Exec sp_DeleteGopY 1
*/

GO 
CREATE PROC sp_selectGopY
AS
	BEGIN
		SELECT * FROM gop_y 
	END
GO

CREATE PROC sp_InsertGopY(@MaGV int, @MaCH int, @NoiDung varchar(max), @NgayTao date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_GopY ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Thêm thất bại góp ý! ' + @NoiDung
				PRINT N'Nội dung không được rỗng'
				RETURN 0
			END 
		IF(@MaGV = '')
			BEGIN
				PRINT N'Thêm thất bại góp ý! ' + @NoiDung
				PRINT N'giáo viên không được rỗng'
				RETURN 0
			END 
		IF(@MaCH = '')
			BEGIN
				PRINT N'Thêm thất bại góp ý! ' + @NoiDung
				PRINT N'Câu hỏi không được rỗng'
				RETURN 0
			END 
		IF(@Ngaytao = '')
			BEGIN
				set @Ngaytao = GETDATE()
			END
		IF( EXISTS (select * from giaovien where MaGiaoVien = @MaGV) AND
				(EXISTS (select * from cauhoi where MaCauHoi = @MaCH)) )
				BEGIN
					INSERT INTO gop_y(MaGiaoVien, MaCauHoi, NoiDung, NgayGopY)
					VALUES (@MaGV, @MaCH, @NoiDung, @NgayTao)
				END
		ELSE 
			BEGIN
				PRINT N'Thêm thất bại Góp Ý! ' + @NoiDung
				PRINT N'Giáo viên không tồn tại! hay'
				PRINT N'Mã câu hỏi không tồn tại!'
				RETURN 1
			END
	END
GO


CREATE PROC sp_UpdateGopY(@MaGY int, @MaGV int, @MaCH int, @NoiDung varchar(max), @NgayTao date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_GopY ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF( NOT EXISTS (select * from gop_y where MaGopY = @MaGY) )
			BEGIN
				Print N'Không tồn tại góp ý!'
				Print @MaGV
				RETURN 0
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Thêm thất bại góp ý! ' + @NoiDung
				PRINT N'Nội dung không được rỗng'
				RETURN 0
			END 
		IF(@MaGV = '')
			BEGIN
				PRINT N'Thêm thất bại góp ý! ' + @NoiDung
				PRINT N'giáo viên không được rỗng'
				RETURN 0
			END 
		IF(@MaCH = '')
			BEGIN
				PRINT N'Thêm thất bại góp ý! ' + @NoiDung
				PRINT N'Câu hỏi không được rỗng'
				RETURN 0
			END 
		IF(@Ngaytao = '')
			BEGIN
				set @Ngaytao = GETDATE()
			END
		IF( EXISTS (select * from giaovien where MaGiaoVien = @MaGV) AND
				(EXISTS (select * from cauhoi where MaCauHoi = @MaCH)) )
				BEGIN
					UPDATE gop_y
					SET MaGiaoVien = @MaGV,
						MaCauHoi = @MaCH,
						NoiDung = @NoiDung,
						NgayGopY = @NgayTao
					WHERE MaGopY = @MaGY
					Print N'Cập nhật thành công góp ý!'
					Print @MaGY	
					RETURN 1
				END
		ELSE
			BEGIN
				PRINT N'Cập nhật thất bại góp ý! '
				PRINT @MaGY
				PRINT N'Mã giáo viên không tồn tại! hay'
				PRINT N'Mã câu hỏi không tồn tại !'
				RETURN 1
			END
		
	END
GO

CREATE PROC sp_DeleteGopY(@MaGY int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_GopY ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF( NOT EXISTS (select * from gop_y where MaGopY = @MaGY) )
			BEGIN
				Print N'Không tồn tại góp ý !'
				Print @MaGY
				RETURN 0
			END
		DELETE gop_y WHERE MaGopY = @MaGY
		Print N'Xóa thành công góp ý!'
		Print @MaGY
		RETURN 1
	END
GO

Exec sp_InsertGopY '1', '1', 'abc', ''
Exec sp_InsertGopY '2', '2', 'abc', ''
Exec sp_InsertGopY '3', '3', 'abc', ''


/*
*** Proc TRALOI ***
1 - Select			Exec sp_selectTraLoi
2 - Insert			Exec sp_InsertTraLoi '1','122','','a'
3 - Edit			Exec sp_UpdateTraLoi '1', 'd', 'g', 'wqe', ''
4 - Delete			Exec sp_DeleteCauHoi 1
*/
GO

CREATE PROC sp_selectTraLoi
AS
	BEGIN
		SELECT * FROM traloi 
	END
GO

CREATE PROC sp_InsertTraLoi(@MaCH int, @NoiDung varchar(max), @DapAn bit, @TenTraLoi varchar(2), @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemCauHoi ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@MaCH = '')
			BEGIN
				PRINT N'Thêm thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Mã câu hỏi không được rỗng'
				RETURN 0
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Thêm thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Nội dungkhông được rỗng'
				RETURN 0
			END
		IF(@TenTraLoi = '')
			BEGIN
				PRINT N'Thêm thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Tên trả lời không được rỗng'
				RETURN 0
			END
		IF( NOT EXISTS (select * from cauhoi where MaCauHoi = @MaCH) )
			BEGIN
				Print N'Không tồn tại câu hỏi !'
				Print @MaCH
				RETURN 0
			END
		IF ( EXISTS (select * from cauhoi where MaCauHoi = @MaCH) AND
			  EXISTS (select * from traloi where TenTraLoi = @TenTraLoi) )
			BEGIN
				Print N'Thêm thất bại câu trả lời!'
				Print @MaCH
				Print N'Câu này đã được thêm!'
				RETURN 0
			END
		INSERT INTO traloi(MaCauHoi, NoiDung, DapAn, TenTraLoi)
		VALUES (@MaCH , @NoiDung , @DapAn , @TenTraLoi )
		RETURN 1
	END
GO

CREATE PROC sp_UpdateTraLoi(@MaCH int, @TenTraLoi varchar(2), @TenTraLoinew varchar(2), @NoiDung varchar(max), @DapAn bit, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemCauHoi ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@MaCH = '')
			BEGIN
				PRINT N'Thêm thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Mã câu hỏi không được rỗng'
				RETURN 0
			END
		IF(@NoiDung = '')
			BEGIN
				PRINT N'Thêm thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Nội dungkhông được rỗng'
				RETURN 0
			END
		IF(@TenTraLoi = '' and @TenTraLoinew = '')
			BEGIN
				PRINT N'Thêm thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Tên trả lời không được rỗng'
				RETURN 0
			END
		IF( NOT EXISTS (select * from traloi where MaCauHoi = @MaCH) )
			BEGIN
				Print N'Không tồn tại câu hỏi !'
				Print @MaCH
				RETURN 0
			END
		IF ( EXISTS (select * from traloi where MaCauHoi = @MaCH) AND
			 NOT EXISTS (select * from traloi where TenTraLoi = @TenTraLoi))
			BEGIN
				PRINT N'Câu hỏi '
				Print @MaCH
				Print N'Không tồn tại câu trả lời !' + @TenTraLoi
				RETURN 0
			END
		IF ( EXISTS (select * from traloi where MaCauHoi = @MaCH) AND
			  EXISTS (select * from traloi where TenTraLoi = @TenTraLoi) AND
			  EXISTS (select * from traloi where TenTraLoi = @TenTraLoinew ) )
			BEGIN
				Print N'Thêm thất bại câu trả lời!'
				Print @MaCH
				Print N'Câu này đã được thêm!'
				RETURN 0
			END
		UPDATE traloi
		SET NoiDung = @NoiDung,
			DapAn = @DapAn,
			TenTraLoi = @TenTraLoinew
		WHERE MaCauHoi = @MaCH AND TenTraLoi = @TenTraLoi
		Print N'Cập nhật thành công Trả lời!'
		Print @MaCH	
		RETURN 1
	END
GO

CREATE PROC sp_DeleteTraLoi(@MaCH int, @TenTraLoi varchar(2), @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_ThemCauHoi ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF(@MaCH = '')
			BEGIN
				PRINT N'Xóa thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Mã câu hỏi không được rỗng'
				RETURN 0
			END
		IF(@TenTraLoi = '')
			BEGIN
				PRINT N'Xóa thất bại câu trả lời! '
				PRINT @MaCH
				PRINT N'Tên trả lời không được rỗng'
				RETURN 0
			END
		IF ( EXISTS (select * from traloi where MaCauHoi = @MaCH) AND
			  EXISTS (select * from traloi where TenTraLoi = @TenTraLoi))
			  BEGIN
				DELETE traloi WHERE MaCauHoi = @MaCH AND TenTraLoi = @TenTraLoi
				Print N'Xóa thành công Câu trả lời!'
				Print @MaCH
				RETURN 1
			  END
		ELSE
			BEGIN
				Print N'Xóa thất bại Câu trả lời!'
				Print @MaCH
				RETURN 1
			END
			  
	END

Exec sp_InsertTraLoi '1','122','','a'
Exec sp_InsertTraLoi '1','122','','b'
Exec sp_InsertTraLoi '1','122','','c'
Exec sp_InsertTraLoi '1','122','','d'


/*
*** Proc Nien Khoa ***
1 - Select			Exec sp_selectNienKhoa
2 - Insert			Exec sp_InsertHe 'Hoan Chinh', '1/12/2019'
3 - Edit			Exec sp_UpdateHe 1, '', '10/20/2019'
4 - Delete			Exec sp_DeleteHe 3
*/

GO

CREATE PROC sp_selectNienKhoa
AS
	BEGIN
		SELECT * FROM nienkhoa 
	END
GO

CREATE PROC sp_InsertNienKhoa (@TenNK varchar(255), @NgayBD date, @NgayKT date, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_NienKhoa ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@TenNK = '')
			BEGIN
				PRINT N'Thêm thất bại Niên khóa! ' + @TenNK
				PRINT N'Tên niên khóa không được rỗng'
				RETURN 0
			END
		IF (@NgayBD = '')
			BEGIN
				Print N'Thêm thất bại Niên khóa! ' + @TenNK
				Print N'Ngày bắt đầu không được rỗng! '
				return 0
			END
		IF (@NgayKT = '')
			BEGIN
				Print N'Thêm thất bại Niên khóa! ' + @TenNK
				Print N'Ngày kết thúc không được rỗng! '
				return 0
			END
		IF( (CONVERT(date, @NgayBD) > CONVERT(date, @NgayKT)) )
			BEGIN
				PRINT N'Thêm thất bại Niên khóa! ' + @TenNK
				PRINT N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc!'
				RETURN 0
			END
		IF( dateadd(day,365,@NgayBD) > CONVERT(date, @NgayKT) )
			BEGIN
				PRINT N'Thêm thất bại Niên khóa! ' + @TenNK
				PRINT N'Ngày kết thúc tối thiểu phải trên 1 năm!'
				RETURN 0
			END
		IF ( EXISTS (select * from nienkhoa where ThoiGianBatDau = @NgayBD) OR
			 EXISTS (select * from nienkhoa where ThoiGianKetThuc = @NgayKT) )
			BEGIN
				Print N'Thêm thất bại Niên khóa! ' + @TenNK
				Print N'Niên khóa này đã tồn tại! '
				return 0
			END
		Insert into nienkhoa(TenNienKhoa, ThoiGianBatDau, ThoiGianKetThuc)
		values(@TenNK, @NgayBD, @NgayKT)
		Print N'Thêm thành công niên khóa ! ' + @TenNK
	END
GO

CREATE PROC sp_UpdateNienKhoa (@MaNK int, @TenNK varchar(255), @NgayBD date, @NgayKT date, @MaGVCV)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_NienKhoa ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@MaNK = '')
			BEGIN
				PRINT N'Cập nhật thất bại Niên khóa! ' + @TenNK
				PRINT N'Mã niên khóa không được rỗng'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from nienkhoa where MaNienKhoa = @MaNK) )
			BEGIN
				PRINT N'Cập nhật thất bại Niên khóa! ' + @TenNK
				PRINT N'Mã niên khóa không tồn tại'
				RETURN 0
			END
		IF (@TenNK = '')
			BEGIN
				PRINT N'Cập nhật thất bại Niên khóa! ' + @TenNK
				PRINT N'Tên niên khóa không được rỗng'
				RETURN 0
			END
		IF (@NgayBD = '')
			BEGIN
				Print N'Cập nhật thất bại Niên khóa! ' + @TenNK
				Print N'Ngày bắt đầu không được rỗng! '
				return 0
			END
		IF (@NgayKT = '')
			BEGIN
				Print N'Cập nhật thất bại Niên khóa! ' + @TenNK
				Print N'Ngày kết thúc không được rỗng! '
				return 0
			END
		IF( (CONVERT(date, @NgayBD) > CONVERT(date, @NgayKT)) )
			BEGIN
				PRINT N'Cập nhật thất bại Niên khóa! ' + @TenNK
				PRINT N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc!'
				RETURN 0
			END
		IF( dateadd(day,365,@NgayBD) > CONVERT(date, @NgayKT) )
			BEGIN
				PRINT N'Cập nhật thất bại Niên khóa! ' + @TenNK
				PRINT N'Ngày kết thúc tối thiểu phải trên 1 năm!'
				RETURN 0
			END
		IF ( EXISTS (select * from nienkhoa where ThoiGianBatDau = @NgayBD) OR
			 EXISTS (select * from nienkhoa where ThoiGianKetThuc = @NgayKT) )
			BEGIN
				Print N'Cập nhật thất bại Niên khóa! ' + @TenNK
				Print N'Niên khóa này đã tồn tại! '
				return 0
			END
		update nienkhoa
		set TenNienKhoa = @TenNK,
			ThoiGianBatDau = @NgayBD,
			ThoiGianKetThuc = @NgayKT
		where MaNienKhoa = @MaNK
		Print N'Cập nhật thành công niên khóa ! ' + @TenNK
	END
GO

CREATE PROC sp_DeleteNienKhoa (@MaNK int, @MaGVCV)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_NienKhoa ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from hocky where MaNienKhoa = @MaNK))
			BEGIN
				Print N'Xóa thất bại hệ!'
				Print @MaNK
				Print N'Niên khóa này đang được sử dụng ở Học kỳ'
			END
		ELSE 
			IF (EXISTS (select * from nienkhoa where MaNienKhoa = @MaNK))
				BEGIN
					DELETE nienkhoa WHERE MaNienKhoa = @MaNK
					Print N'Xóa thành công Niên khóa !'
					Print @MaNK
				END
			ELSE
				BEGIN
					Print N'Không tồn tại Niên khóa !'
					Print @MaNK
				END
	END


GO
exec sp_DeleteNienKhoa 6
exec sp_selectNienKhoa
exec sp_InsertNienKhoa 'Nien Khoa 2017 - 2018','09/06/2017','09/06/2018'
exec sp_InsertNienKhoa 'Nien Khoa 2018 - 2020','09/06/2018','09/06/2020'

exec sp_UpdateNienKhoa '5', 'Nien Khoa 2017 - 2018','09/06/2017','09/06/2018'
GO

/*
*** Proc bomon ***
1 - Select			Exec sp_SelectHocKy
2 - Insert			Exec sp_InsertBoMon 1, 'Hoan Chinh', '1/12/2019', ''
3 - Edit			Exec sp_UpdateBoMon 6, 2, '', '', 0
4 - Delete			Exec sp_DeleteBoMon 5
*/

CREATE PROC sp_SelectHocKy
AS
	BEGIN
		SELECT * FROM hocky
	END
GO

CREATE PROC sp_InsertHocKy (@TenHocKy nvarchar(255), @NgayBatDau date, @NgayKetThuc date, @MaNienKhoa int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_NienKhoa ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@NgayBatDau = '')
			BEGIN
				Print N'Thêm thất bại học kỳ! ' + @TenHocKy
				Print N'Ngày bắt đầu không được rỗng! '
				return 0
			END
		IF (@NgayKetThuc = '')
			BEGIN
				Print N'Thêm thất bại học kỳ! ' + @TenHocKy
				Print N'Ngày kết thúc không được rỗng! '
				return 0
			END
		IF (@MaNienKhoa = '')
			BEGIN
				Print N'Thêm thất bại học kỳ! ' + @TenHocKy
				Print N'Mã niên khóa không được rỗng! '
				return 0
			END
		IF ( NOT EXISTS (select * from nienkhoa where MaNienKhoa = @MaNienKhoa) )
			BEGIN
				Print N'Thêm thất bại học kỳ! ' + @TenHocKy
				Print N'Mã niên khóa không tồn tại! '
			END
		IF( (CONVERT(date, @NgayBatDau) > CONVERT(date, @NgayKetThuc)) )
			BEGIN
				PRINT N'Thêm thất bại học kỳ! ' + @TenHocKy
				PRINT N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc!'
				RETURN 0
			END
		IF( (CONVERT(date, @NgayBatDau) > CONVERT(date, @NgayKetThuc)) )
			BEGIN
				PRINT N'Thêm thất bại học kỳ! ' + @TenHocKy
				PRINT N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc!'
				RETURN 0
			END

		IF ( EXISTS (select * from nienkhoa where MaNienKhoa = @MaNienKhoa))
			BEGIN
				declare @NgayBDNK date, @NgayKTNK date, @NgayKTHKCuoi date ;		
				select @NgayBDNK =  ThoiGianBatDau from nienkhoa where MaNienKhoa = @MaNienKhoa
				select @NgayKTNK =  ThoiGianKetThuc from nienkhoa where MaNienKhoa = @MaNienKhoa
				IF( (CONVERT(date, @NgayBatDau) < CONVERT(date, @NgayBDNK)) OR 
					(CONVERT(date, @NgayKetThuc) > CONVERT(date, @NgayKTNK)) ) 
					BEGIN
						Print N'Thêm thất bại học kỳ! ' + @TenHocKy
						Print N'Ngày bắt đầu của học kỳ phải >= ngày bắt đầu niên khóa! Hay'
						Print N'Ngày kết thúc của học kỳ phải =< ngày ngày kết thúc niên khóa!'
						RETURN 0
					END
				select TOP 1 @NgayKTHKCuoi = hocky.NgayKetThuc from nienkhoa, hocky where nienkhoa.MaNienKhoa = hocky.MaNienKhoa
				ORDER BY hocky.MaHocKy DESC
				IF ( (CONVERT(date, @NgayKTHKCuoi) > CONVERT(date, @NgayBatDau)) )
					BEGIN
						Print N'Thêm thất bại học kỳ! ' + @TenHocKy
						Print N'Ngày bắt đầu của học kỳ phải >= ngày kết thúc của học kỳ trước có cùng niên khóa!'
						RETURN 0
					END
			END 
		
		INSERT INTO hocky(TenHocKy, NgayBatDau, NgayKetThuc, MaNienKhoa)
		VALUES (@TenHocKy, @NgayBatDau, @NgayKetThuc, @MaNienKhoa)
	END
GO

CREATE PROC sp_UpdateHocKy (@MaHocKy int, @TenHocKy nvarchar(255), @NgayBatDau date, @NgayKetThuc date, @MaNienKhoa int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_NienKhoa ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (@NgayBatDau = '')
			BEGIN
				set @NgayBatDau = GETDATE()
			END
		IF (@NgayKetThuc = '')
			BEGIN
				set @NgayKetThuc = GETDATE()
			END
		IF (@MaNienKhoa = '')
			BEGIN
				Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
				Print N'Mã niên khóa không được rỗng! '
			END
		IF ( NOT EXISTS (select * from nienkhoa where MaNienKhoa = @MaNienKhoa) )
			BEGIN
				Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
				Print N'Mã niên khóa không tồn tại! '
			END
		IF (@MaHocKy = '')
			BEGIN
				Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
				Print N'Mã học kỳ không được rỗng! '
			END
		IF ( NOT EXISTS (select * from hocky where MaHocKy = @MaHocKy) )
			BEGIN
				Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
				Print N'Mã học kỳ không tồn tại! '
			END
		IF( (CONVERT(date, @NgayBatDau) > CONVERT(date, @NgayKetThuc)) )
			BEGIN
				PRINT N'Cập nhật thất bại học kỳ! ' + @TenHocKy
				PRINT N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc!'
				RETURN 0
			END
		IF( (CONVERT(date, @NgayBatDau) > CONVERT(date, @NgayKetThuc)) )
			BEGIN
				PRINT N'Cập nhật thất bại học kỳ! ' + @TenHocKy
				PRINT N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc!'
				RETURN 0
			END

		IF ( EXISTS (select * from nienkhoa where MaNienKhoa = @MaNienKhoa))
			BEGIN
				declare @NgayBDNK date, @NgayKTNK date, @NgayKTHKCu date, @NgayBDKTiep date ;		
				select @NgayBDNK =  ThoiGianBatDau from nienkhoa where MaNienKhoa = @MaNienKhoa
				select @NgayKTNK =  ThoiGianKetThuc from nienkhoa where MaNienKhoa = @MaNienKhoa
				IF( (CONVERT(date, @NgayBatDau) < CONVERT(date, @NgayBDNK)) OR 
					(CONVERT(date, @NgayKetThuc) > CONVERT(date, @NgayKTNK)) ) 
					BEGIN
						Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
						Print N'Ngày bắt đầu của học kỳ phải >= ngày bắt đầu niên khóa! Hay'
						Print N'Ngày kết thúc của học kỳ phải =< ngày ngày kết thúc niên khóa!'
						RETURN 0
					END
				
				select @NgayKTHKCu = NgayKetThuc from hocky where MaHocKy = @MaHocKy
				select @NgayBDKTiep = min(NgayBatDau) from hocky where NgayBatDau > @NgayKTHKCu 
				IF ( (CONVERT(date, @NgayBDKTiep) < CONVERT(date, @NgayKetThuc)) )
					BEGIN
						Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
						Print N'Ngày kết thúc của học kỳ này phải < ngày bắt đầu của học kỳ tiếp theo có cùng niên khóa!'
						RETURN 0
					END
				
				DECLARE @NgayBDHKCu date, @NgayKTHKTruoc date
				select @NgayBDHKCu = NgayBatDau from hocky where MaHocKy = @MaHocKy
				select @NgayKTHKTruoc = max(NgayKetThuc) from hocky where NgayKetThuc < @NgayBDHKCu 
				IF ( (CONVERT(date, @NgayKTHKTruoc) > CONVERT(date, @NgayBatDau)) )
					BEGIN
						Print N'Cập nhật thất bại học kỳ! ' + @TenHocKy
						Print N'Ngày bắt đầu của học kỳ này phải > ngày kết thúc của học kỳ trước có cùng niên khóa!'
						RETURN 0
					END
			END 
		
		UPDATE hocky
		SET	TenHocKy = @TenHocKy,
				NgayBatDau = @NgayBatDau,
				NgayKetThuc = @NgayKetThuc,
				MaNienKhoa = @MaNienKhoa
		WHERE MaHocKy = @MaHocKy
	END
GO

CREATE PROC sp_DeleteHocKy (@MaHocKy int, @MaGVCV int)
AS
	BEGIN
		IF ( NOT EXISTS (select * from phanquyen_giaovien where MaGV = @MaGVCV and MaPhanQuyen = @Quyen_NienKhoa ))	  
			BEGIN
				Print N'Giáo viên chưa được cấp quyền cho chức năng này ! '
				Print @MaGVCV
				return 0
			END
		IF (EXISTS (select * from cauhoi_hocky where MaHocKy = @MaHocKy))
			BEGIN
				Print N'Xóa thất bại học kỳ!'
				Print @MaHocKy
				Print N'Mã học kỳ đang được sử dụng'
				RETURN 1
			END
		IF (EXISTS (select * from hocky where MaHocKy = @MaHocKy))
			BEGIN
				DELETE cauhoi_hocky WHERE MaHocKy = @MaHocKy
				Print N'Xóa thành công hoc kỳ!'
				Print @MaHocKy
			END
		ELSE
			BEGIN
				Print N'Không tồn tại hoc kỳ!'
				Print @MaBM
			END
	END
GO

-- CREATE PROC sp_UpdateHocKyNgayKetThuc (@MaHocKy int, @NgayKetThucmoi date)
-- AS
-- 	BEGIN
-- 		declare @NgayKTOld date, @NgayBDKTIEP date
		
-- 	  select @NgayKTOld = NgayKetThuc from hocky where MaHocKy = @MaHocKy
-- 	  select @NgayBDKTIEP =  min(NgayBatDau) from hocky where NgayBatDau > @NgayKTOld 
-- 		IF ( @NgayBDKTIEP = '')
-- 			BEGIN
-- 				UPDATE hocky
-- 				SET NgayKetThuc = @NgayKetThucmoi
-- 				WHERE MaHocKy = @MaHocKy
-- 				PRINT N'SUA THOAI MAI'
-- 				RETURN 1
-- 			END
-- 		ELSE
-- 			IF ( (CONVERT(date, @NgayBDKTIEP) > CONVERT(date, @NgayKetThucmoi)))
-- 				BEGIN
-- 					UPDATE hocky
-- 					SET NgayKetThuc = @NgayKetThucmoi
-- 					WHERE MaHocKy = @MaHocKy
-- 					PRINT N'Sua Thoai Mai'
-- 					return 1
-- 				END
-- 			ELSE
-- 				BEGIN
-- 					PRINT N'kHONG DUOC Sua'
-- 					return 1
-- 				END
-- 	END

-- GO
EXEC sp_UpdateHocKyNgayKetThuc '1', '03/10/2018'

sp_selectNienKhoa

sp_selectHocKy 
exec sp_InsertHocKy HK1,'09/06/2017', '03/06/2018', '5'
exec sp_InsertHocKy HK2,'03/06/2018', '09/06/2018', '5'
exec sp_InsertHocKy HK3,'09/06/2018', '09/06/2019', '5'
exec sp_UpdateHocKy '1', 'HK1', '09/06/2017', '03/05/2018','5'
exec sp_UpdateHocKy '2', 'HK1', '03/08/2018', '09/06/2018','5'



/*
*** Proc CAUHOI_HOCKY ***
1 - Select			Exec sp_selecCHHK
2 - Insert			EXEC sp_InsertPQGV '11', '2'
3 - Edit			exec sp_UpdatePQGV 4,8,12
4 - Delete			exec sp_DeletePQGV 4,10
*/

GO 
CREATE PROC sp_selecCHHK
AS
	BEGIN
		SELECT * FROM cauhoi_hocky 
	END
GO

CREATE PROC sp_InsertCHHK(@MaHocKy int, @MaCauHoi int)
AS
	BEGIN
		IF (@MaHocKy = '')
			BEGIN
				PRINT N'Thêm thất bại câu hỏi học kỳ!'
				PRINT @MaHocKy
				PRINT N'Mã học kỳ không được rỗng'
				RETURN 0
			END
		IF (@MaCauHoi = '')
			BEGIN
				PRINT N'Thêm thất bại câu hỏi học kỳ!'
				PRINT @MaHocKy
				PRINT N'Mã câu hỏi không được rỗng'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from hocky where MaHocKy = @MaHocKy) )
			BEGIN
				PRINT N'Thêm thất bại câu hỏi học kỳ!'
				PRINT @MaHocKy
				PRINT N'Mã học kỳ không tồn tại'
				RETURN 0
			END
		IF ( NOT EXISTS (select * from cauhoi where MaCauHoi = @MaCauHoi) )
			BEGIN
				PRINT N'Thêm thất bại câu hỏi học kỳ!'
				PRINT @MaHocKy
				PRINT N'Mã giáo viên không tồn tại'
				RETURN 0
			END
		IF ( EXISTS (select * from cauhoi_hocky where MaHocKy = @MaHocKy and MaCauHoi = @MaCauHoi) )
			BEGIN
				PRINT N'Thêm thất bại câu hỏi học kỳ!'
				PRINT @MaHocKy
				PRINT N'Mã câu hỏi cho học kỳ này đã được thêm'
				RETURN 0
			END
		DECLARE @MaNienKhoa int, @MaCauHoiNK int
			set @MaNienKhoa = select count(MaHocKy) from hocky group by MaNienKhoa having count(MaHocKy) >= 2
		INSERT INTO cauhoi_hocky(MaHocKy, MaCauHoi)
		VALUES (@MaHocKy, @MaCauHoi)
	END
GO




select * from chucvu
SELECT * FROM giaovien
SELECT * FROM bomon








 


