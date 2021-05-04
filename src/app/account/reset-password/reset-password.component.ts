import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { AccountService } from 'src/app/services/account.service';
import { AlertService } from 'src/app/services/alert.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';

enum TokenStatus {
  Validating,
  Valid,
  Invalid
}

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.css']
})

export class ResetPasswordComponent implements OnInit {
  TokenStatus = TokenStatus;
  tokenStatus = TokenStatus.Validating;
  token = null;
  form:FormGroup;
  loading = false;
  submitted = false;
  constructor(private formBuilder: FormBuilder, private route: ActivatedRoute, private router: Router, private accountService: AccountService,private alertService: AlertService, private customValidator: CustomValidatorService) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      password:['',[Validators.required,Validators.minLength(6)]],
      passwordConfirm : ['', [Validators.required,Validators.minLength(6)]],
    },{
      validator: this.customValidator.passwordMatchValidator("password","passwordConfirm")
    });
    const token = this.route.snapshot.queryParams['token']; 

    this.router.navigate([],{relativeTo: this.route, replaceUrl:true}); //remover token do url
    this.accountService.validateResetToken(token).pipe(first()).subscribe({
      next:() => {
        this.token = token;
        this.tokenStatus = TokenStatus.Valid;
      },
      error:() => {
        this.tokenStatus = TokenStatus.Invalid;
      }
    });
  }

 onSubmit() {
   this.submitted = true;
   this.alertService.clear();
   if(this.form.invalid) {
     return;
   }
   this.loading = true;
   this.accountService.resetPassword(this.token,this.f.password.value,this.f.passwordConfirm.value).pipe(first()).subscribe({
     next: () => {
       this.alertService.success("Password reset successful, you can login");
       this.router.navigate(['../login'], {relativeTo: this.route});
     },
     error: error => {
       this.alertService.error(error);
       this.loading = false;
     }
   })
 }
 
  get f() { return this.form.controls; }
}
