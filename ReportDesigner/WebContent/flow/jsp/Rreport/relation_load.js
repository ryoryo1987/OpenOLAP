//if(self.name=="frm_displayScreen"){
//alert(self.name);
//alert(parent.name);
if(parent.name=="frm_screen"||parent.name=="frm_mapping"||parent.name=="frm_result"){
//	document.all.imgHozon.style.display='none';
	document.all.mode1.disabled=true;
	document.all.mode1.style.filter='Gray()';
	document.all.mode2.disabled=true;
	document.all.mode2.style.filter='Gray()';
	document.all.mode3.disabled=true;
	document.all.mode3.style.filter='Gray()';
	document.all.del_btn.disabled=true;
	document.all.del_btn.style.filter='Gray()';
	document.all.save_btn.disabled=true;
	document.all.save_btn.style.filter='Gray()';
}

