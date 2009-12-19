use utf8;

use Test::More tests => 1 + 1;

BEGIN {
    use_ok('Email::MIME::RFC2047::MailboxList');
};

my @tests = (
    '=?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, =?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>',
    [
        { name => 'Keld Jørn Simonsen', address => 'keld@dkuug.dk' },
        { name => 'André Pirard', address => 'PIRARD@vm1.ulg.ac.be' },
    ],
);

for(my $i=0; $i<@tests; $i+=2) {
    my ($string, $expect) = ($tests[$i], $tests[$i+1]);

    my $mailbox = Email::MIME::RFC2047::MailboxList->parse($string);
    is_deeply($mailbox, $expect, "parse $string");
}

