

function school_day_change() {
  v=$('cico_school_day_status').value;
  if (v=='In School') {
  $$('#cico_form select.student_day').each(function(selbox) {
      selbox.value='No Data';
      selbox.enable();

      });
  }
  else {
  $$('#cico_form select').each(function(selbox) {
      selbox.value  = v;
      selbox.disable();
      });

  };
  update_cico_totals();

}

function student_row_change(student_row) {
  // isNaN
  // disable other columns and set to same
  // else
  // enable other columns and set to No Data unless already numeric
  v=student_row.value;
  obs=student_row.up('tr').select('.period_expectation_value select');

  if (isNaN(v))
  {
    obs.each(function(selbox){
        if (selbox.id != student_row.id ) {
        selbox.value=v;
        selbox.disable();
        };
        });
  }
  else
  {
    obs.each(function(selbox){
        if (isNaN(selbox.value) && selbox.id != student_row.id) {selbox.value='No Data'};
        });
  obs.invoke('enable');
  };

  update_cico_totals();

}


function student_day_change(student_day) {
  v=student_day.value;
  obs=student_day.up('tr').next('tr').select('.student_day select')
  if (v=='Present') {
  obs.each(function(selbox) {
      selbox.value='No Data';
      selbox.enable();

      });
  }
  else {
  obs.each(function(selbox) {
      selbox.value  = v;
      selbox.disable();
      });

  };

  update_cico_totals();
}






function update_cico_totals() {

  $$('#cico_form  table.student_day').each(function(student_day){
    count=0;
    total=0;
    expectation_totals = new Array();
    period_totals = new Array();
      student_day.select(".period_expectation_value select").each(function(score){
        pindex=score.classList[0].split('_')[2];
        eindex=score.classList[0].split('_')[3];
        score_value=score.options[score.selectedIndex].value;
        v=parseInt(score_value);
        if (score_value == 'No Data') {v=0};
        if (v>=0) {
          count=count+1;
          total=total+v;
          if (isNaN(period_totals[pindex])) {
          period_totals[pindex] = v;
          }
          else
          {
          period_totals[pindex] += v;
          };

          if (isNaN(expectation_totals[eindex])) {
          expectation_totals[eindex] = v;
          }
          else
          {
            expectation_totals[eindex] += v;
          };

        }

      });
      percent = Math.round(100*(100*(total/(count * parseInt($('cico_max_score').value)) )),2)/100;
      if (isNaN(percent)) {percent = ''}
      else {percent = percent + '%'};
      student_day.down(".student_day_total span.total_value").innerHTML=percent;
      period_totals.each(function(p,pi){
          student_day.down(".period_"+pi).innerHTML=p;
          });

      expectation_totals.each(function(e,ei){
          student_day.down(".expectation_"+ei).innerHTML=e;
          });
      });




}


function check_same_boxes(obj) {
  $$('.'+obj.className).each(function(s){
      s.checked=obj.checked;
      });

}

function nested_object_delete(obj) {
  obj.up().hide();
  obj.previous().value=true;

}


