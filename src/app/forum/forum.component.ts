import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { User } from 'src/app/models/user.model';
import { Question } from '../models/question.model';
import { AccountService } from '../services/account.service';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddquestionComponent } from './addquestion/addquestion.component';


@Component({
  selector: 'app-forum',
  templateUrl: './forum.component.html',
  styleUrls: ['./forum.component.css']
})
export class ForumComponent implements OnInit {
  
  user: User;
  string : string;
  payload;
  Questions : Question[];
  questionString: string[] = [];
  status: string;
  noQuestions:string;
  constructor(private accountService: AccountService, private dialog: MatDialog) { 
  }

  ngOnInit(): void {
    this.questions();
    this.noQuestions = "";
  }

  public questions() {
    this.accountService.GetQuestions().subscribe(
      (response: Question[]) => {
      this.Questions = response['data'];
      this.noQuestions = "";
      
      if(!response['data']) {
        this.noQuestions = "No Questions!"
      }
    },
    (error: HttpErrorResponse) => {
      this.noQuestions = error.message;
    });
  }
  getUserId()  {
    this.string = localStorage.getItem('user');
    this.user = (JSON.parse(this.string));
    if (this.user.token) {
      this.payload = this.user.token.split(".")[1];
      this.payload = window.atob(this.payload);
      const userString =  JSON.parse(this.payload);
      return parseInt(userString.UserID);
    } 
  }

  onCreate() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = false;  
    dialogConfig.width = "40%"
    dialogConfig.height = "55%"
    this.dialog.open(AddquestionComponent,dialogConfig);
  } 

}
