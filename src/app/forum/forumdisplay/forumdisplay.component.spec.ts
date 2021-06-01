import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ForumdisplayComponent } from './forumdisplay.component';

describe('ForumdisplayComponent', () => {
  let component: ForumdisplayComponent;
  let fixture: ComponentFixture<ForumdisplayComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ForumdisplayComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ForumdisplayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
