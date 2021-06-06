import { Component, Inject, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AnswersService } from 'src/app/services/answers.service';
import { AccountService } from 'src/app/services/account.service';
import * as _ from 'lodash';



@Component({
  selector: 'app-addanswer',
  templateUrl: './addanswer.component.html',
  styleUrls: ['./addanswer.component.css']
})
export class AddanswerComponent implements OnInit   {
 question_id;
  urls = new Array<string>();
  imageError:string;
  image:string;
  constructor(private accountService: AccountService,private router: Router,private route: ActivatedRoute,private dialogRef: MatDialogRef< AddanswerComponent>,private answerService: AnswersService, @Inject(MAT_DIALOG_DATA) public data:any) { 
    this.question_id=data;
  }

  ngOnInit(): void {

  }

  onSubmit() {
    this.answerService.form.get('questionID').setValue(this.question_id);
    if(!this.service.form.get('ID').value) {
      if (this.answerService.form.invalid) {
        return;
    }
    
    this.accountService.createAnswer(this.answerService.form.value).pipe(first()).subscribe({
      next: () => {
        //this.router.navigate(['../forum'],{relativeTo: this.route});
      }
    });
  this.onClose();
  setTimeout(() => {
    window.location.reload();
  },500);
 
  } else {
    if (this.answerService.form.invalid) {
      return;
  }
  setTimeout(() => {
    window.location.reload();
  },500);
  }
}

  onClose() {
    this.answerService.form.reset();
    this.dialogRef.close();
  }

  populateForm() {
    this.answerService.form.setValue(this.answerService);
  }

  get service() {
    return this.answerService;
  }

  fileChangeEvent(fileInput) {
    this.imageError = null;
          if (fileInput.target.files && fileInput.target.files[0]) {
              // Size Filter Bytes
              const max_size = 20971520;
              const allowed_types = ['image/png', 'image/jpeg'];
              const max_height = 15200;
              const max_width = 25600;
  
              if (fileInput.target.files[0].size > max_size) {
                  this.imageError = 'Maximum size allowed is ' + max_size / 1000 + 'MB';
                      return false;
              }
  
              if (!_.includes(allowed_types, fileInput.target.files[0].type)) {
                  this.imageError = 'Only allowed images are of type JPG or PNG';
                  return false;
              }
              const reader = new FileReader();
              reader.onload = (e: any) => {
                  const image = new Image();
                  image.src = e.target.result;
                  image.onload = rs => {
                      const img_height = rs.currentTarget['height'];
                      const img_width = rs.currentTarget['width'];
                      if (img_height > max_height && img_width > max_width) {
                          this.imageError =
                              'Maximum dimentions allowed ' +
                              max_height +
                              'x' +
                              max_width +
                              'px';
                          return false;
                      } else {
                          const imgBase64Path = e.target.result;
                          this.image = imgBase64Path;
                          this.answerService.form.get('attachement').setValue(imgBase64Path);
                          //window.location.reload();
                          
                      }
                  };
              };
              reader.readAsDataURL(fileInput.target.files[0]);
          }
      }
}