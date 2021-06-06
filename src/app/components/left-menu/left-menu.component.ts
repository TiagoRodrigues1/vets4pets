import { Component, OnInit } from '@angular/core';
import { animateText, onSideNavChange } from 'src/app/animations/animations';
import { Pet } from 'src/app/models/pet.model';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { SidenavService } from 'src/app/services/sidenav.service';
import { Roles } from 'src/app/models/roles.enum';

interface Page {
  link: string;
  name: string;
  icon: string;
}

@Component({
  selector: 'app-left-menu',
  templateUrl: './left-menu.component.html',
  styleUrls: ['./left-menu.component.css'],
  animations: [onSideNavChange, animateText]
})
export class LeftMenuComponent implements OnInit {
  user: User;
  payload;
  Pet : Pet[];
  userH:User;
  public sideNavState: boolean = false;
  public linkText: boolean = false;
  
  public pages: Page[] = [
    {name: 'Veterinaries', link:'/clinic', icon: 'store'},
    {name: 'Pets', link:'/pets', icon: 'pets'},
    {name: 'Adoptions', link:'/adoptions', icon: 'favorite'},
    {name: 'Forum', link:'/forum', icon: 'supervisor_account'},
  ]

  public pagesVet: Page[] = [
    {name: 'Forum', link:'/forum', icon: 'supervisor_account'},
    {name: 'Appointments',link:'/vet',icon:'calendar_today'},
  ]

  public pagesAdm: Page [] = [
    {name: 'BackOffice',link:'/admin',icon:'lock'},
  ]
  
  string: string;
  
  constructor(private _sidenavService: SidenavService,private accountService: AccountService) { 
    this.accountService.user.subscribe(x => this.user = x);
  }

  ngOnInit(): void {
    this.getUser();
  }

  getUser() {
    this.string = localStorage.getItem('user');
    this.userH = (JSON.parse(this.string));
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

  get isNormal() {
    return this.user && this.user.userType === Roles.User;
  }

  onSinenavToggle() {
    this.sideNavState = !this.sideNavState
    
    setTimeout(() => {
      this.linkText = this.sideNavState;
    }, 200)
    this._sidenavService.sideNavState$.next(this.sideNavState)
  }

  logout() {
    this.accountService.logout();
}

}
