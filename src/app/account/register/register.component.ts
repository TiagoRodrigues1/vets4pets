import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  form: FormGroup;
  loading = false;
  submitted = false;
  emailPattern = '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$';
  
  constructor(private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private accountService: AccountService,
    private customValidator : CustomValidatorService) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      name: ['', Validators.required],
      passwordConfirm : ['', [Validators.required,Validators.minLength(6)]],
      email: ['', Validators.compose([Validators.required,Validators.pattern(this.emailPattern)])],
      username: ['', Validators.required],
      password: ['', [Validators.required, Validators.minLength(6)]],
      gender: ['', Validators.required],
      contact: ['', Validators.required],
      birthday: ['', Validators.required],
  },{
    validator: this.customValidator.passwordMatchValidator("password","passwordConfirm")
  });
  }

  get f() { return this.form.controls; }

  onSubmit() {
    this.submitted = true;

    // reset alerts on submit

    // stop here if form is invalid
    if (this.form.invalid) {
        return;
    }

    this.loading = true;
    this.accountService.register(this.form.value)
        .pipe(first())
        .subscribe({
            next: () => {
                this.router.navigate(['../login'], { relativeTo: this.route });
            },
            error: error => {
                this.loading = false;
            }
        });
}

get passwordConfirm() {
  return this.form.get("passwordConfirm").value
}
}
