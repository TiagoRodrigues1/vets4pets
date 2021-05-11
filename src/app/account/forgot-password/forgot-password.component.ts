import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { finalize, first } from 'rxjs/operators';
import { AccountService } from 'src/app/services/account.service';
import { AlertService } from 'src/app/services/alert.service';

@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.css']
})
export class ForgotPasswordComponent implements OnInit {
  form:FormGroup;
  loading = false;
  submitted = false;
  emailPattern = '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$';
  error:string;
  constructor(private formBuilder: FormBuilder, private accountService: AccountService, private alertService: AlertService) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      email: ['',[Validators.required,Validators.pattern(this.emailPattern)]]
  });
  }

  get f() { return this.form.controls; }

  onSubmit() {
    this.submitted = true;
    this.alertService.clear();
    if(this.form.invalid) {
      return;
    }
    this.loading = true,
    this.accountService.forgotPassword(this.f.email.value).pipe(first()).pipe(finalize(() => this.loading = false)).subscribe(
      {next: () => this.alertService.success('Please check your email for instructions'),
      error: error => {this.alertService.error(error); this.error = error; }
    });
  }
}
