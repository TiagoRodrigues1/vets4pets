import { Component, OnInit } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { User } from 'src/app/models/user.model';
import { Answer } from 'src/app/models/answer.model';
import { AccountService } from 'src/app/services/account.service';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddquestionComponent } from 'src/app/forum/addquestion/addquestion.component';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';

@Component({
  selector: 'app-myanswers',
  templateUrl: './myanswers.component.html',
  styleUrls: ['./myanswers.component.css']
})
export class MyanswersComponent implements OnInit {

  string : string;
  payload;
  answers : Answer[];
  status: string;
  idUser;
  user:User;
  constructor(private accountService: AccountService, private dialog: MatDialog,private formService: CustomValidatorService) { 
  this.idUser=this.formService.getUserId();
  this.user = this.formService.user;

  }

  ngOnInit(): void {
    this.GetAnswers();
  }

  public GetAnswers() {
    this.accountService.getAnswersOfUser(this.idUser).subscribe(
      (response: Answer[]) => {
      this.answers = response['data'];
      console.log(this.answers);
    },
    (error: HttpErrorResponse) => {
      alert(error.message);
    });
  }

  onCreate() {
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
}
