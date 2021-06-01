import { Component, OnInit } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { Question } from 'src/app/models/question.model';
import { AccountService } from 'src/app/services/account.service';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddquestionComponent } from 'src/app/forum/addquestion/addquestion.component';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';


@Component({
  selector: 'app-myquestions',
  templateUrl: './myquestions.component.html',
  styleUrls: ['./myquestions.component.css']
})
export class MyquestionsComponent implements OnInit {

  user_id;
  string : string;
  payload;
  Questions : Question[];
  status: string;
  constructor(private accountService: AccountService, private dialog: MatDialog,private formService: CustomValidatorService) { 
  this.user_id=this.formService.getUserId();
  }

  ngOnInit(): void {
    this.questions();
  }

  public questions() {
    this.accountService.getQuestionsOfUser(this.user_id).subscribe(
      (response: Question[]) => {
      this.Questions = response['data'];
      console.log(this.Questions);
    },
    (error: HttpErrorResponse) => {
      alert(error.message);
    });
  }

  onCreate() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "40%"
    dialogConfig.height = "55%"
    this.dialog.open(AddquestionComponent,dialogConfig);
  } 
}
