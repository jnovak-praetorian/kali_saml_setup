<?php
$metadata['https://HOSTNAME/simplesamlphp/module.php/saml/sp/metadata.php/default-sp'] = array(
    'AssertionConsumerService' => 'https://HOSTNAME/simplesamlphp/module.php/saml/sp/saml2-acs.php/default-sp',
    'SingleLogoutService'      => 'https://HOSTNAME/simplesamlphp/module.php/saml/sp/saml2-logout.php/default-sp',
    //'NameIDFormat' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
    'simplesaml.nameidattribute' => 'email',
);

$metadata['https://example.customer.com/saml/metadata.xml'] = array(
    'AssertionConsumerService' => 'https://example.customer.com/saml/acs.endpoint',
    'SingleLogoutService'      => 'https://example.customer.com/saml/logout.endpoint',
    'NameIDFormat' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified',
    'simplesaml.nameidattribute' => 'email',
);
