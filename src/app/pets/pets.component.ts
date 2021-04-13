import { Component, OnInit } from '@angular/core';
import { User } from 'src/app/models/user.model';

@Component({
  selector: 'app-pets',
  templateUrl: './pets.component.html',
  styleUrls: ['./pets.component.css']
})
export class PetsComponent implements OnInit {
  user: User;
  string : string;
  constructor() { }

  ngOnInit(): void {
  }


  pets() {
    this.string = localStorage.getItem('user');
    this.user = (JSON.parse(this.string));
    console.log(this.user);
  }
}
