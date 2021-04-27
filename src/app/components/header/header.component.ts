import { Component, Input, OnInit } from '@angular/core';
import { MatSidenav } from '@angular/material/sidenav';
import { Router } from '@angular/router';
import { Roles } from 'src/app/models/roles.enum';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
  @Input() sidenav:  MatSidenav;
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

  ngOnInit(): void {
  }
    
}
