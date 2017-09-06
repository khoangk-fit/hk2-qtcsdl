GO
USE [WWSGO]
GO

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

CREATE PROC sp_InsertHe (@TenHe varchar(255), @NgayTao date)
AS
	BEGIN
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		Insert into he values(@TenHe, @NgayTao)
		Print N'Thêm thành công Hệ ! ' + @TenHe
	END
GO

CREATE PROC sp_UpdateHe (@MaHe int,@TenHe varchar(255), @NgayTao date)
AS
	BEGIN
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

CREATE PROC sp_DeleteHe (@MaHe int)
AS
	BEGIN
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

CREATE PROC sp_InsertChucVu (@TenCV varchar(255), @NgayNhanChuc date, @NgayMienNhiem date)
AS
	BEGIN
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

CREATE PROC sp_UpdateChucVu (@MaCV int,@TenCV varchar(255), @NgayNhanChuc date, @NgayMienNhiem date)
AS
	BEGIN
		
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

CREATE PROC sp_DeleteChucVu (@MaCV int)
AS
	BEGIN
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
						 @NgayTao date, @TruongBoMon int)
AS
	BEGIN
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
						 @NgayTao date, @TruongBoMon int)
AS
	BEGIN
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

CREATE PROC sp_DeleteBoMon (@MaBM int)
AS
	BEGIN
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

CREATE PROC sp_InsertPhanQuyen (@TenPQ varchar(255), @NgayTao date)
AS
	BEGIN
		IF (@NgayTao = '')
			BEGIN
				set @NgayTao = GETDATE()
			END
		Insert into phanquyen(TenPhanQuyen, NgayTao) values(@TenPQ, @NgayTao)
		Print N'Thêm thành công quyền ! ' + @TenPQ
	END
GO

CREATE PROC sp_UpdatePhanQuyen (@MaPQ int,@TenPQ varchar(255), @NgayTao date)
AS
	BEGIN
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

CREATE PROC sp_DeletePhanQuyen (@MaPQ int)
AS
	BEGIN
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
								@Ngayvaolam date, @GVQL int, @TrangThai BIT, @cmnd varchar(20))
AS
	BEGIN
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
								@Ngayvaolam date, @GVQL int, @TrangThai BIT, @cmnd varchar(20))
AS
	BEGIN
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

CREATE PROC sp_DeleteGiaoVien (@MaGV int)
AS
	BEGIN
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
*** Proc GIAOVIEN ***
1 - Select			Exec sp_selectCauHoi
2 - Insert			EXEC sp_InsertCauHoi 1,'','1','ABC la gi ?','1',1,1,'',1,''
3 - Edit			EXEC sp_UpdateCauHoi 1,'1','','1','ABC','0.23','1','','','',''
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
								  @TrangThai BIT, @Thutu int)
AS
	BEGIN
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
								  @TrangThai BIT, @Thutu int)
AS
	BEGIN
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

CREATE PROC sp_DeleteCauHoi (@MaCH int)
AS
	BEGIN
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

select * from chucvu
SELECT * FROM giaovien
SELECT * FROM bomon








 


