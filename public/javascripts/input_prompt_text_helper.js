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

