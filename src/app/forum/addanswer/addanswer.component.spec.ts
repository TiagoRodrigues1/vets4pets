import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddanswerComponent } from './addanswer.component';

describe('AddanswerComponent', () => {
  let component: AddanswerComponent;
  let fixture: ComponentFixture<AddanswerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddanswerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddanswerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
