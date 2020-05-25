// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery-3.4.1.min
//= require popper
//= require tether
//= require bootstrap
//= require_tree .


var checkAcessos = function(){
  $(".check-acessos").each(function(){
    $(this).attr("checked", true);
  });
}

var uncheckAcessos = function(){
  $(".check-acessos").each(function(){
    $(this).attr("checked", false);
  });
}

const pgstrans = {};

pgstrans.displayRecarga = (tipo) => {
  $(".icone-menu").removeClass("menu-ativo");
  $(".recarga .img_" + tipo).addClass("menu-ativo");
  $(".campos").hide();
  $(".recarga ." + tipo).show();
  $(".recarga #recarga").show();
  $(".recarga #rechargeValue").val("");
  $(".recarga .rechargeType").val("");
  $(".recarga #tipo_ativo").val(tipo);
}

pgstrans.carregaProdutosPorParceiro = (self) => {
  $.ajax({
    type: "GET",
    url: "/produtos.json?partner_id="+ self.value,
    success: function(data){
      $("#produto_id").html("<option value=\"\" selected=\"selected\">Todos</option>");
      $(data).each(function(){
        $("#produto_id").append("<option value=\"" + this.id + "\">" + this.description + "</option>")
      });
    }
  });
}

$(function(){
  
  $(".recarga .rechargeType").change(function(){
    $(".recarga #rechargeValue").val(this.value.split("-")[1]);
    $(".recarga .talao" + $("#tipo_ativo").val() + "").show();
  })

  $(".recarga #recargaForm").submit(function(e) {
    e.preventDefault();

    let message = "";
    $(".validate.v" + $("#tipo_ativo").val()).each(function(){
      if($(this).val() == ""){
        if(message == ""){
          message = $(this).data("message");
          $(this).focus();
          return;
        }
      }
    });

    if(message !== ""){
      $.alert({
        title: 'Validação!',
        content: message,
      });
      return;
    }

    $(".recarga .talao" + $("#tipo_ativo").val() + "").show();

    $.confirm({
      title: 'Confirmação!',
      content: 'TEM A CERTEZA QUE DESEJA EFECTUAR A RECARGA?',
      buttons: {
        confirmar: {
          text: 'Confirmar',
          btnClass: 'btn-warning',
          action: function(){
            var form = $(".recarga #recargaForm");
            var url = form.attr('action');
            $.ajax({
              type: "POST",
              url: url,
              data: form.serialize(),
              success: function(data){
                $.alert(data.mensagem);
              },
              error: function(xhr, ajaxOptions, thrownError){
                var data = JSON.parse(xhr.responseText);
                var erroObject = JSON.parse(xhr.responseText)
                var stackthrow = (erroObject ? erroObject.erro : "")
                $.alert(data.mensagem + ' - ' + stackthrow);
              }
            });
          }
        },
        cancelar: {
          text: 'Cancelar',
          btnClass: 'btn-danger',
          action: function(){
            $.alert('cancelado!');
          }
        }
      }
    });
  });

});

$(document).ajaxStart(function() {
  $(".modal_loader").show();
});
$(document).ajaxComplete(function() {
  $(".modal_loader").hide();
});