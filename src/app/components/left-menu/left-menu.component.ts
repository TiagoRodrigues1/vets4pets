import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { animateText, onSideNavChange } from 'src/app/animations/animations';
import { Pet } from 'src/app/models/pet.model';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { SidenavService } from 'src/app/services/sidenav.service';

interface Page {
  link: string;
  name: string;
  icon: string;
  click: string;
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
  public sideNavState: boolean = false;
  public linkText: boolean = false;
  
  public pages: Page[] = [
    {name: 'Pets', link:'/pets', icon: 'pets',click: 'pets()'},
    {name: 'Starred', link:'some-link', icon: 'star',click: ''},
    {name: 'Send email', link:'some-link', icon: 'send',click: ''}
  ]
  
  constructor(private _sidenavService: SidenavService,private accountService: AccountService) { 
    this.user = this.accountService.userValue;

  }

  ngOnInit(): void {

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
