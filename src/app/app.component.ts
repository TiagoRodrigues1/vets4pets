import { Component } from '@angular/core';
import { User } from './models/user.model';
import { AccountService } from './services/account.service';
import { Router } from '@angular/router';
import { Roles } from './models/roles.enum';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'LPI';
  user: User;

    constructor(private accountService: AccountService,public router: Router) {
        this.accountService.user.subscribe(x => this.user = x);
    }

    get isAdmin() {
      return this.user && this.user.userType === Roles.Admin;
    }

    get isVet() {
      return this.user && this.user.userType === Roles.Vet;
    }

    get isManager() {
      return this.user && this.user.userType === Roles.Manager;
    }
  
    
}
