--2/Đặt vấn đề: Một giáo viên đang thực hiện thao tác xem danh sách các bộ đề thì một giáo viên khác tạo thêm một bộ đề nữa vào tập dữ liệu BODE mà giáo viên kia đang truy vấn.
--Dữ liệu tranh chấp: Bảng BODE	
--1/Đặt vấn đề:  Một giáo viên đang thực hiện thao tác xem thang điểm các câu hỏi thì một giáo viên khác chèn thêm một câu hỏi vào tập dữ liệu CAUHOI mà giáo viên kia đang truy vấn.
--Dữ liệu tranh chấp: Bảng CAUHOI

--T1
--create proc gv_bode
alter proc gv_bode
as begin tran
--fix: set tran isolation level serializable
declare @mabode char(10)

begin try
declare cur cursor local for select MaBoDe
						       from cauhoi CH
							   open cur
print 'Ma cau hoi:'
fetch next from cur into @mabode
while(@@FETCH_STATUS = 0)
begin
print +@mabode
waitfor delay '0:0:10'
fetch next from cur into @bode
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
exec gv_bode
--T2
--fix: declare cur cursor for select MaBoDe
begin tran
	begin try
		if not exists(select * from cauhoi where MaBoDe = @mabode)
		begin
		
		SET IDENTITY_INSERT bode ON
			insert into bode(TenBoDe,NgayTao,NoiDung,ThangDiem,ThuTu,MaBoDe,MaGiaoVien)
			values (@tenbode,@ngaytao,@noidung,@thangdiem,@thutu,@mabode,@magiaovien)
		
		end
		else 
		begin
			print N'Đã tồn tại.'
			rollback tran
			return
		end
		waitfor delay '0:0:10'
	end try
	begin catch
		declare @ErrorMsg varchar(2000)
		select @ErrorMsg = N'Lỗi: ' + ERROR_MESSAGE()
		raiserror(@ErrorMsg, 16,1)
		rollback tran
		return
	end catch
	print N'Đã thêm thành công. ' +cast(@mabode as nvarchar(10))
commit tran

select * from bode
exec gv_bode --them cac thong tin insert ngan cach bang cac dau phay.
select * from bode
