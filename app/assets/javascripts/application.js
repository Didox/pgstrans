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
//= require chartkick
//= require Chart.bundle
//= require_tree .

const pgstrans = {};

pgstrans.salvaSaldo = function(self, cc_id, elenValue){
  let data = {}
  if(elenValue){
    data.cc_id = cc_id
    data[elenValue] = $(self).parents(".flex").find("input[name=" + elenValue + "]").val()
  }
  else{
    data["conta_corrente_id[]"] = cc_id 
  }

  $("input[type=hidden]").each(function(){
    data[this.name] = this.value
  });

  $.ajax({
    type: "POST",
    url: `/conta_correntes/conciliacao/aplicar.json`,
    data: data,
    success: function(data){
      $(self).parents("td").find(".sucesso").html("Altereação feita")
      setTimeout(() => {
        $(self).parents("td").find(".sucesso").html("")
        window.location.reload();
      }, 2000);
    }
  });
}

pgstrans.displayRecargaDstv = (tipo) => {
  $(".recarga #DSTVMenu").hide();
  $(".recarga #recarga").show();
  $(".clearFieldjs").val("");
}

pgstrans.displayRecargaEnde = (tipo) => {
  $(".recarga #ENDEMenu").hide();
  $(".recarga #recarga").show();
  $(".clearFieldjs").val("");
}

pgstrans.alteraCompartilha = (grupo_usuario_id, self) => {
  $.ajax({
    type: "PUT",
    url: `/grupo_usuarios/${grupo_usuario_id}.json`,
    data: {
      grupo_usuario: {
        id: grupo_usuario_id,
        escrita: self.value
      }
    }
  });
}



pgstrans.carregaDescontos = (self) => {
  $.ajax({
    type: "GET",
    url: "/partners/" + self.value + "/desconto_parceiros.json",
    success: function(data){
      $("#remuneracao_parceiro_desconto_id_partner_id_" + self.value).html("<option value=\"\" selected=\"selected\">[Selecione]</option>");
      $(data).each(function(){
        $("#remuneracao_parceiro_desconto_id_partner_id_" + self.value).append("<option value=\"" + this.id + "\">" + this.porcentagem + "%</option>")
      });
    }
  });
}

pgstrans.displayRecarga = (tipo) => {
  $(".icone-menu").removeClass("menu-ativo");
  $(".recarga .img_" + tipo).addClass("menu-ativo");
  $(".campos").hide();
  $(".recarga ." + tipo).show();
  $(".recarga #recarga").show();
  $(".recarga #rechargeValue").val("");
  $(".recarga .rechargeType").val("");
  $(".recarga #tipo_ativo").val(tipo);
  $(".recarga #DSTVMenu").hide();
  $(".recarga #ENDEMenu").hide();
  $(".recarga #recarga").show();

  if(tipo.toLowerCase() == "dstv"){
    $(".recarga #DSTVMenu").show();
    $(".recarga #recarga").hide();
  }
  else if(tipo.toLowerCase() == "ende"){
    $(".recarga #ENDEMenu").show();
    $(".recarga #recarga").hide();
  }
  
  $(".clearFieldjs").val("")
}

pgstrans.mostraSaldo = (self) => {
  $("#saldoUsuario").html("");
  $.ajax({
    type: "GET",
    url: "/usuarios/"+ self.value + ".json",
    success: function(usuario){
      $("#saldoUsuario").html("Saldo do usuário " + usuario.nome + ": <b>R$ " + usuario.saldo.toLocaleString('pt-br', {minimumFractionDigits: 2}) + "<b>");
    }
  });
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


var checkAcessos = function(){
  $(".check-acessos").each(function(){
    $(this).prop("checked", true);
  });
}

var uncheckAcessos = function(){
  $(".check-acessos").each(function(){
    $(this).prop("checked", false);
  });
}

var timerPagamentoProcessando = false;
const processarPagamento = function(){
  var form = $(".recarga #recargaForm");
  var url = form.attr('action');

  $(".modal_loader").show();

  $.ajax({
    type: "POST",
    url: url,
    data: form.serialize(),
    success: function(data){
      $(".modal_loader").hide();
      $(".clearFieldjs").val("")

      if(!data.redirect){
        $.alert(data.mensagem);
      }
      else{
        if(data.sucesso && data.redirect){
          window.location.href="/vendas/" + data.venda_id + "/recibo";
        }
        else{
          $.alert(data.mensagem);
        }
      }
    },
    error: function(xhr, ajaxOptions, thrownError){
      $(".modal_loader").hide();
      var data = JSON.parse(xhr.responseText);
      var erroObject = JSON.parse(xhr.responseText)
      var stackthrow = (erroObject && erroObject.erro ? ' - ' + erroObject.erro : "")

      if(!erroObject.redirect){
        $.alert(data.mensagem + stackthrow);
      }
      else{
        window.location.href="/vendas/" + erroObject.venda_id + "/recibo";
      }

    },
    timeout: 120000 // sets timeout to 120 seconds
  });
}

var timerSubmeterRecarga = null;
const submeterRecarga = function() {
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

  $(".validate.cOpcional" + $("#tipo_ativo").val()).each(function(){
    if($(this).val() != "" && $(this).attr("type") == "email"){
      if( $(this).val().indexOf("@") == -1 || $(this).val().indexOf(".") == -1 ){
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
          clearInterval(timerPagamentoProcessando)
          timerPagamentoProcessando = setInterval(function(){
            processarPagamento()
            clearInterval(timerPagamentoProcessando)
          }, 300);
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
};

$(function(){
  $( ".autocomplete" ).autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "/usuarios.json?select_usuarios_not_self=ok",
        dataType: "json",
        data: {
          nome: $( ".autocomplete" ).val()
        },
        success: function( usuarios ) {
          $(".options-autocomplete").html("<option value=''>[Selecione]</option>")
          for(var usuario of usuarios){
            $(".options-autocomplete").append("<option value='" + usuario.id + "'>" + usuario.nome + "</option>")
          }
        }
      });
    },
  });
  
  $(".recarga .rechargeType").change(function(){
    let valor = $(this).find("option[value=" + this.value + "]").data("valor").trim();
    $("#rechargeValue").val(valor);
    $("#rechargeValue").attr("readonly", "readonly")
    $("#valor_customizado").val("")
    $(".recarga .talao" + $("#tipo_ativo").val() + "").show();

    if($(this).hasClass("vdstv") > 0 && $(this).find("option:selected").html().toLowerCase().indexOf("boxoffice") !== -1){
      $("#rechargeValue").removeAttr("readonly")
      $("#valor_customizado").val("true")
    }
    else if($(this).hasClass("vunitel") > 0 && $(this).find("option:selected").html().toLowerCase().indexOf("variável") !== -1){
      $("#rechargeValue").removeAttr("readonly")
      $("#valor_customizado").val("true")
    }
    else if(parseFloat(valor) < 1){
      $("#rechargeValue").removeAttr("readonly")
      $("#valor_customizado").val("true")
    }
  });

  $(".recarga #recargaForm").submit(function(e) {
    e.preventDefault();
    
    clearInterval(timerSubmeterRecarga)
    timerSubmeterRecarga = setInterval(function(){
      submeterRecarga()
      clearInterval(timerSubmeterRecarga)
    }, 300)
  });
});

$(document).ajaxStart(function() {
  $(".modal_loader").show();
});
$(document).ajaxComplete(function() {
  $(".modal_loader").hide();
});
