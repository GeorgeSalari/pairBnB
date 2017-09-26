// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){

  var form = document.querySelector('#cardForm');
  var submit = document.querySelector("#submit-payment-btn");
  var authorization = $(".demo-frame").data("token");

  braintree.client.create({
    authorization: authorization
  }, function (clientErr, clientInstance) {
    if (clientErr) {
      console.error(clientErr);
    }

    // This example shows Hosted Fields, but you can also use this
    // client instance to create additional components here, such as
    // PayPal or Data Collector.

    braintree.hostedFields.create({
      client: clientInstance,
      styles: {
        'input': {
          'font-size': '14px'
        },
        'input.invalid': {
          'color': 'red'
        },
        'input.valid': {
          'color': 'green'
        }
      },
      fields: {
        number: {
          selector: '#card-number',
          placeholder: '4111 1111 1111 1111'
        },
        cvv: {
          selector: '#cvv',
          placeholder: '123'
        },
        expirationDate: {
          selector: '#expiration-date',
          placeholder: '10/2019'
        }
      }
    }, function (hostedFieldsErr, hostedFieldsInstance) {
      if (hostedFieldsErr) {
        console.error(hostedFieldsErr);
        return;
      }

      submit.removeAttribute('disabled');

      form.addEventListener('submit', function (event) {
        event.preventDefault();

        hostedFieldsInstance.tokenize(function (tokenizeErr, payload) {
          if (tokenizeErr) {
            console.error(tokenizeErr);
            return;
          }

          // If this was a real integration, this is where you would
          // send the nonce to your server.
          console.log('Got a nonce: ' + payload.nonce);
          document.querySelector('input[name="checkout_form[payment_method_nonce]"]').value = payload.nonce;
          form.submit();
        });
      }, false);
    });
  });

})
