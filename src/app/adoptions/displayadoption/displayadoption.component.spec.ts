import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DisplayadoptionComponent } from './displayadoption.component';

describe('DisplayadoptionComponent', () => {
  let component: DisplayadoptionComponent;
  let fixture: ComponentFixture<DisplayadoptionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DisplayadoptionComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DisplayadoptionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
