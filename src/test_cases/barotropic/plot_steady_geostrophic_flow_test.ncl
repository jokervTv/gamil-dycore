load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

if (.not. isdefined("file_prefix")) then
  file_prefix = systemfunc("a=$(ls *.h0.*.nc | head -n1) && echo ${a/\.h0.*/}")
  system("echo '[Notice]: Use file_prefix " + file_prefix + ".'")
end if

file_names = systemfunc("ls " + file_prefix + "*h0*.nc")

wks = gsn_open_wks("pdf", file_prefix)

res = True
res@gsnDraw = False
res@gsnFrame = False
res@mpOutlineOn = False
res@mpFillOn = False
res@cnConstFEnableFill = True

res_panel = True

f0 = addfile(file_names(0), "r")
gh0 = f0->gh(0,:,:)
gh0 = gh0 / 9.80616
do t = 0, dimsizes(file_names) - 1
  system("echo '=> " + file_names(t) + "'")
  f = addfile(file_names(t), "r")
  gh = f->gh(0,:,:)
  gh = gh / 9.80616
  res@gsnLeftString = "Height (m)"
  res@gsnRightString = cd_string(f->time, "Day %j Hour %H")
  plot0 = gsn_csm_contour_map(wks, gh, res)
  error = gh - gh0
  copy_VarCoords(gh, error)
  res@gsnLeftString = "Error (m)"
  plot1 = gsn_csm_contour_map(wks, error, res)
  gsn_panel(wks, (/plot0,plot1/), (/2,1/), res_panel)
end do