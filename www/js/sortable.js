function makeSortable(el) {
    el.sortable({
        //clone a helper which will append to the end so that it would visually
        //preserve the checked status while dragging
        helper: 'clone',
        placeholder: {
            element: function(item) {
              //clone the item and show it so the placeholder replicate the item 
              //and will be reflected in our values
              var clone = item.clone();
              clone.show();
              
              //uncheck the box so the original box won't mess with our values
              var checkbox = item.children(':checkbox');
              checkbox.prop('was-checked', checkbox.prop('checked'));
              checkbox.prop('checked', false);
          
              return clone;
            },
            update: function() {
                return;
            }
        },
        change: function(event, ui) {
            //propogate changes in position directly to the element being moved
            $(event.target).trigger('change');
        },
        stop: function(event, ui) {
          //now we want to restore the checked status if it was checked
          var checkbox = ui.item.children(':checkbox');
          checkbox.prop('checked', checkbox.prop('was-checked'));
        }
    });
}