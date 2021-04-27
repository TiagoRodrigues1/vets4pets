import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { onMainContentChange } from '../animations/animations';
import { User } from '../models/user.model';
import { AccountService } from '../services/account.service';
import { SidenavService } from '../services/sidenav.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  animations: [ onMainContentChange ]

})
export class HomeComponent implements OnInit {
  user: User;
  public onSideNavChange: boolean;

  constructor(private accountService: AccountService,private _sidenavService: SidenavService, public router: Router) {
      this.user = this.accountService.userValue;
      this._sidenavService.sideNavState$.subscribe(res => {
        console.log(res)
        this.onSideNavChange = res;
    })
  }

  ngOnInit(): void {
    
  }
  

}
