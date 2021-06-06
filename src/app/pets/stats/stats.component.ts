import { DatePipe } from '@angular/common';
import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ChartDataSets } from 'chart.js';
import { Color, Label } from 'ng2-charts';
import { Prescription } from 'src/app/models/prescription.model';
import { AccountService } from 'src/app/services/account.service';

@Component({
  selector: 'app-stats',
  templateUrl: './stats.component.html',
  styleUrls: ['./stats.component.css']
})
export class StatsComponent implements OnInit {
  loading:boolean = true;
  presc:Prescription[];
  errorPrescApi:string;
  lineChartData: ChartDataSets[] = [];
  
  lineChartLabels: Label[] = [];
  lineChartOptions = {
    responsive: true,
  };
  lineChartColors: Color[] = [
    { 
      borderColor: 'black',
      backgroundColor: 'rgba(54, 183, 136,0.28)',
    },
  ];
  weights:number[] = [];
  lineChartLegend = true;
  lineChartPlugins = [];
  lineChartType = 'line';
  strings:Label[] = [];
  constructor(private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data: any,private datePipe:DatePipe) { }

  ngOnInit(): void {
    this.getPrescriptions();
    
  }

  getPrescriptions() {
    let resp = this.accountService.getPrescription(this.data.ID);
    resp.subscribe(report => { this.presc = report['data'] as Prescription[]; this.loading = false;
    this.presc.forEach(pre => this.weights.push(pre.weight));
    let datachart:ChartDataSets[] = [{data:this.weights,label:'Weight'}];
    this.lineChartData = datachart;
    this.presc.forEach(pre => this.strings.push(this.datePipe.transform(pre.date,'dd/MM/yyyy')));
      let lineChart: Label[] = this.strings; 
    this.lineChartLabels = lineChart;
  },
      error => this.errorPrescApi = error);

      
  }  
  

}
