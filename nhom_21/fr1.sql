--1/Đặt vấn đề:  Một giáo viên đang thực hiện thao tác xem thang điểm các câu hỏi thì một giáo viên khác chèn thêm một câu hỏi vào tập dữ liệu CAUHOI mà giáo viên kia đang truy vấn.
--Dữ liệu tranh chấp: Bảng CAUHOI

--T1
--create proc gv_cauhoi
alter proc gv_cauhoi
as begin tran
fix: set tran isolation level serializable
declare @macauhoi char(10)

begin try
declare cur cursor local for select MaCauHoi
						       from cauhoi CH
							   open cur
print 'Ma cau hoi:'
fetch next from cur into @macauhoi
while(@@FETCH_STATUS = 0)
begin
print +@macauhoi
waitfor delay '0:0:10'
fetch next from cur into @macauhoi
end
close cur
		deallocate cur
end try
	begin catch
		declare @ErrorMsg varchar(2000)
		select @ErrorMsg = N'Lỗi: ' + ERROR_MESSAGE()
		raiserror(@ErrorMsg, 16,1)
		rollback tran
		return
	end catch
commit tran
go
exec gv_cauhoi
--T2
--fix: declare cur cursor for select MaCauHoi
begin tran
	begin try
		if not exists(select * from cauhoi where MaCauHoi = @macauhoi)
		begin
		--THÊM SP	
		SET IDENTITY_INSERT ChiTietDonHang ON
			insert into cauhoi(MaGiaoVien,MaBoDe,MaBoMon,NoiDung,ThangDiem,MucDo,LuaChon,NgayTao,TrangThai,ThuTu,MaCauHoi)
			values (@magiaovien,@mabode,@mabomon,@noidung,@thangdiem,@mucdo,@luachon,@ngaytao,@trangthai,@thutu,@macauhoi)
		--	SET IDENTITY_INSERT ChiTietDonHang OFF
		end
		else 
		begin
			print N'Đã tồn tại.'
			rollback tran
			return
		end
		waitfor delay '0:0:010'
	end try
	begin catch
		declare @ErrorMsg varchar(2000)
		select @ErrorMsg = N'Lỗi: ' + ERROR_MESSAGE()
		raiserror(@ErrorMsg, 16,1)
		rollback tran
		return
	end catch
	print N'Đã thêm thành công. ' +cast(@macauhoi as nvarchar(10))
commit tran

select * from cauhoi
exec gv_cauhoi gv1,001,001,Cau 1,0.2,1,0,'2017-09-01',0,1
select * from cauhoi
