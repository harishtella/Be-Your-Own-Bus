function input_remove_prompt_text(obj, prompt_text){
  if (obj.getValue() == prompt_text){
    obj.setValue('');
  }
}

function input_add_prompt_text(obj, prompt_text){ 
  if (obj.getValue() == ''){
    obj.setValue(prompt_text);
  }
}

function input_prompt_clear_for_submit(obj_id, prompt_text){
  obj = document.getElementById(obj_id);
  if (obj.getValue() == prompt_text){
    obj.setValue('');
  }
}
