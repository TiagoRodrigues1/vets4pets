import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
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

  constructor(private adminService: AdminService,private route: ActivatedRoute,private router: Router,private dialogRef: MatDialogRef<AdminComponent>, private accountService:AccountService,private val: CustomValidatorService) { }

  ngOnInit(): void {
  }
  onSubmit() {
    if(!this.service.form.get('ID').value) {
      if (this.adminService.form.invalid) {
        return;
    }
    this.adminService.form.get('UserID').setValue(this.val.getUserId());
    console.log(this.adminService.form.value);
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
}
