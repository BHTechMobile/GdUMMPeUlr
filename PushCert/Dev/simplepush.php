<?php

// Put your device token here (without spaces):e9de8c6c265b0c39cc762f890e5b6ffc46397a509e61df3c8863900c5d12e5f5
    $deviceToken = '89d92e2c9bc2fd72e7634f7a858f4b66d2b55adcc4813eed81245bf28e2e5d9a';

//$deviceToken = '38886830e96f6dbb936ea76a97eeda951a2e9c85a3f69bba7ef22e1113b5b49d';
//$deviceToken = 'f83da3ddcc710dfc760027468bbc70e80dc9169e8cb42a5fbed0359719101449';
// Put your private key's passphrase here:
$passphrase = '1234';

// Put your alert message here:
//$message = 'My first push notification!';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck_dev.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
    $bds = 'My first push notification!';
    $apiloc = 'My first push notification!';
    
    $message['alert'] = array(
                              'action-loc-key' => $apiloc,
                              'body' => $bds,
                              'appointment_id' => '43'
                              );
    
$body['aps'] = array(
                     'alert' => array(
                                      'action-loc-key' => $apiloc,
                                      'body' => $bds,
                                      'appointment_id' => '43'
                                      ),
	'sound' => 'default',
    'type' => 'APPOINTMENT'
	);

// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
