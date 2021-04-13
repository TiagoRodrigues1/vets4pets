import { Component, OnInit } from '@angular/core';
import { animateText, onSideNavChange } from 'src/app/animations/animations';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { SidenavService } from 'src/app/services/sidenav.service';

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
  public sideNavState: boolean = false;
  public linkText: boolean = false;

  public pages: Page[] = [
    {name: 'Pets', link:'/pets', icon: 'pets'},
    {name: 'Starred', link:'some-link', icon: 'star'},
    {name: 'Send email', link:'some-link', icon: 'send'},
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
