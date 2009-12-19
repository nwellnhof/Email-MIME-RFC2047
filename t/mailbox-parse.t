use utf8;

use Test::More tests => 2 + 4 * 2;

BEGIN {
    use_ok('Email::MIME::RFC2047::Mailbox');
    use_ok('Email::MIME::RFC2047::Address');
};

my @tests = (
    '"Nick Wellnhofer" <wellnhofer@aevum.de>',
    { name => 'Nick Wellnhofer', address => 'wellnhofer@aevum.de' },
    'Nick Wellnhofer <wellnhofer@aevum.de>',
    { name => 'Nick Wellnhofer', address => 'wellnhofer@aevum.de' },
    '=?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>',
    { name => 'Keld Jørn Simonsen', address => 'keld@dkuug.dk' },
    '=?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>',
    { name => 'André Pirard', address => 'PIRARD@vm1.ulg.ac.be' },
);

for(my $i=0; $i<@tests; $i+=2) {
    my ($string, $expect) = ($tests[$i], $tests[$i+1]);

    my $mailbox = Email::MIME::RFC2047::Mailbox->parse($string);
    is_deeply($mailbox, $expect, "parse mailbox $string");

    my $address = Email::MIME::RFC2047::Address->parse($string);
    is_deeply($address, $expect, "parse address $string");
}

