import { Component, OnInit } from '@angular/core';
import {Router, ActivatedRoute, Params} from '@angular/router';
import { Subscription } from 'rxjs';
import { Question } from 'src/app/models/question.model';
import { HttpErrorResponse } from '@angular/common/http';
import { AccountService } from 'src/app/services/account.service';
import { Answer } from 'src/app/models/answer.model';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddanswerComponent } from '../addanswer/addanswer.component';
import { AddquestionComponent } from '../addquestion/addquestion.component';
import { User } from 'src/app/models/user.model';

@Component({
  selector: 'app-forumdisplay',
  templateUrl: './forumdisplay.component.html',
  styleUrls: ['./forumdisplay.component.css']
})
export class ForumdisplayComponent implements OnInit {
  question:Question;
  answers: Answer[];
  private routeSub: Subscription;
  id;
  idUser;
  status;
  users:User[];
  questionString:String[] = [];
  error:string;
  user:User;
  errorUser:string;
  errorResponse:string;
  errorUsers:string;
  imageObject:any;
  constructor(private dialog: MatDialog, private route: ActivatedRoute,private router: Router,private accountService: AccountService, private formService: CustomValidatorService) {}
  loading:boolean = true;
  ngOnInit(): void {
    this.routeSub = this.route.params.subscribe(params => {
      this.id=params['id'];
    });
  this.idUser = this.formService.getUserId();
  this.getQuestion();
  setTimeout(() => {
    this.getAnswers();
  },500);
  
  }

  getQuestion(){
      this.accountService.GetQuestion(this.id).subscribe(
        (response: Question) => {
        this.question = response['data'];
        this.splitString();
        this.getUser(this.question.UserID);
        this.imageObject = [{
          image: this.question.attachement,
          thumbImage: this.question.attachement,
        }];
        this.error = "";
      },
      (error: HttpErrorResponse) => {
        this.error = error.message;
      });
    }

    getUser(id:number) {
      this.accountService.getUser(id).subscribe(
        (response: User) => {
        this.user = response['data'];
      },
      (error: HttpErrorResponse) => {
        this.errorUser = error.message;
      });
    }
    
    getUserAnswer(id:number) {
      this.accountService.getUser(id).subscribe(
        (response: User) => {
        this.users.push(response['data']);
        
      },
      (error: HttpErrorResponse) => {
        this.errorUsers = error.message;
      });
    }
    
  getAnswers(){
    this.accountService.getAnswers(this.id).subscribe(
      (response: Answer[]) => {
      this.answers = response['data'];
      this.loading = false;
    },
    (error: HttpErrorResponse) => {
      this.errorResponse = error.message;
    });
  }

  onCreate(id:number) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = false;  
    dialogConfig.width = "40%"
    dialogConfig.height = "48%"
    dialogConfig.data=id;
    this.dialog.open(AddanswerComponent,dialogConfig);
  }

  onCreateQuestion() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = false;  
    dialogConfig.width = "40%"
    dialogConfig.height = "55%"
    this.dialog.open(AddquestionComponent,dialogConfig);
  } 

  deleteAnswer(id:number){
    this.accountService.deleteAnswer(id).subscribe(() => this.status = 'Delete Sucessful');
    window.location.reload();
  }

  deleteQuestion(id:number){
    this.accountService.deleteQuestion(id).subscribe(() => this.status = 'Delete Sucessful');
  }

  splitString() {
    for(var i = 0, charsLength = this.question.question.length; i < charsLength; i+=200) {
      this.questionString.push(this.question.question.substring(i,i+=200));
    }
  }
}
