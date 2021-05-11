import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import * as _ from 'lodash';
import { first } from 'rxjs/operators';
import { AccountService } from 'src/app/services/account.service';
import { AdminService } from 'src/app/services/admin.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { AdminComponent } from '../admin.component';

@Component({
  selector: 'app-add-clinic',
  templateUrl: './add-clinic.component.html',
  styleUrls: ['./add-clinic.component.css']
})
export class AddClinicComponent implements OnInit {
  imageError: string;

  constructor(private adminService: AdminService,private route: ActivatedRoute,private router: Router,private dialogRef: MatDialogRef<AdminComponent>, private accountService:AccountService,private val: CustomValidatorService) { }

  ngOnInit(): void {
  }
  onSubmit() {
    if(!this.service.form.get('ID').value) {
      if (this.adminService.form.invalid) {
        return;
    }
    this.adminService.form.get('UserID').setValue(this.val.getUserId());
    this.accountService.createClinic(this.adminService.form.value).pipe(first()).subscribe({
      next: () => {
        this.router.navigate(['../admin'],{relativeTo: this.route})
      }
    });
    this.onClose();
    window.location.reload();
  } else {
    if(this.adminService.form.invalid) {
      return;
    }
    this.accountService.editClinic(this.adminService.form.get('ID').value,this.adminService.form.value).subscribe();
    this.onClose();
    window.location.reload();
  }
}
  onNoClick() {
    this.onClose();
  }
  get service() {
    return this.adminService;
  }

  onClose() {
    this.adminService.form.reset();
    this.dialogRef.close();
  }

  populateForm() {
    console.log(this.adminService);
    this.adminService.form.setValue(this.adminService);
  }

  fileChangeEvent(fileInput) {
    this.imageError = null;
          if (fileInput.target.files && fileInput.target.files[0]) {
              // Size Filter Bytes
              const max_size = 20971520;
              const allowed_types = ['image/png', 'image/jpeg'];
              const max_height = 15200;
              const max_width = 25600;
  
              if (fileInput.target.files[0].size > max_size) {
                  this.imageError =
                      'Maximum size allowed is ' + max_size / 1000 + 'MB';
  
                  return false;
              }
  
              if (!_.includes(allowed_types, fileInput.target.files[0].type)) {
                  this.imageError = 'Only allowed images are of type JPG or PNG';
                  return false;
              }
              const reader = new FileReader();
              reader.onload = (e: any) => {
                  const image = new Image();
                  image.src = e.target.result;
                  image.onload = rs => {
                      const img_height = rs.currentTarget['height'];
                      const img_width = rs.currentTarget['width'];
                      console.log(img_height, img_width);
                      if (img_height > max_height && img_width > max_width) {
                          this.imageError =
                              'Maximum dimentions allowed ' +
                              max_height +
                              'x' +
                              max_width +
                              'px';
                          return false;
                      } else {
                          const imgBase64Path = e.target.result;
                          this.adminService.form.get('profilePicture').setValue(imgBase64Path)                          
                      }
                  };
              };
              reader.readAsDataURL(fileInput.target.files[0]);
          }
      }
}
