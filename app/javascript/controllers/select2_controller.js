import {Controller} from "@hotwired/stimulus"
import $ from 'jquery';
import Select2 from 'select2'

export default class extends Controller {
  static targets = ["select"];
  static values = {allowNew: Boolean}
  connect() {
    if (this.hasAllowNewValue) {
      this.tags = this.allowNewValue
    } else {
      this.tags = false
    }
    Select2()
    let elem = this.element

    $(elem).select2({
      theme: 'bootstrap-5',
      width: '100%',
      dropdownCssClass: 'select2-arrow',
      placeholder : "選択してください",
      tags: this.tags,
      allowClear: true,
    })
    $(elem)
      .on('select2:select',function() {
        let event = new Event('change', { bubbles: true })
        this.dispatchEvent(event);
      })
      .on('select2:clear',function(){
        let event = new Event('change', { bubbles: true })
        this.dispatchEvent(event);
      })
      .on('select2:open',function(e){
        $(".select2-search__field[aria-controls='select2-" + e.target.id + "-results']")[0].focus();
      })
    if($.fn.modal){
      $.fn.modal.Constructor.prototype.enforceFocus = function() {};
    }
  }
}

