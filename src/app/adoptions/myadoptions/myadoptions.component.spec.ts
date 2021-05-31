import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MyadoptionsComponent } from './myadoptions.component';

describe('MyadoptionsComponent', () => {
  let component: MyadoptionsComponent;
  let fixture: ComponentFixture<MyadoptionsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MyadoptionsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MyadoptionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
