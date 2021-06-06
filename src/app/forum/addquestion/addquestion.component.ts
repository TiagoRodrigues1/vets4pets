import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { MatDialogRef } from '@angular/material/dialog';
import { QuestionService } from 'src/app/services/question.service';
import { AccountService } from 'src/app/services/account.service';
import * as _ from 'lodash';

@Component({
  selector: 'app-addquestion',
  templateUrl: './addquestion.component.html',
  styleUrls: ['./addquestion.component.css']
})
export class AddquestionComponent implements OnInit {
 
  imageError:String;
  image:String;
  constructor(private accountService: AccountService,private router: Router,private route: ActivatedRoute,private dialogRef: MatDialogRef< AddquestionComponent>,private questionService: QuestionService) { }

  ngOnInit(): void {
    
  }

  onSubmit() {
      if(!this.service.form.get('ID').value) {
        if (this.questionService.form.invalid) {
          return;
      }
    this.accountService.createQuestion(this.questionService.form.value).pipe(first()).subscribe({
      next: () => {
        this.router.navigate(['../forum'],{relativeTo: this.route});
      }
    });
    this.onClose();
    window.location.reload();
  } else {
    if (this.questionService.form.invalid) {
      return;
  }
    window.location.reload();
  }
}

  onClose() {
    this.questionService.form.reset();
    this.dialogRef.close();
  }

  populateForm() {
    this.questionService.form.setValue(this.questionService);
  }

  get service() {
    return this.questionService;
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
                          this.questionService.form.get('attachement').setValue(imgBase64Path);
                          //window.location.reload();
                          
                      }
                  };
              };
              reader.readAsDataURL(fileInput.target.files[0]);
          }
      }
}