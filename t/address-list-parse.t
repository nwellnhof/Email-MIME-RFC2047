use utf8;

use Test::More tests => 1 + 1;

BEGIN {
    use_ok('Email::MIME::RFC2047::AddressList');
};

my @tests = (
    '"Group 1 (Test)": =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, =?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>;, wellnhofer@aevum.de',
    [
        {
            name => 'Group 1 (Test)',
            mailbox_list => [
                { name => 'Keld Jørn Simonsen', address => 'keld@dkuug.dk' },
                { name => 'André Pirard', address => 'PIRARD@vm1.ulg.ac.be' },
            ],
        },
        {
            address => 'wellnhofer@aevum.de',
        },
    ],
);

for(my $i=0; $i<@tests; $i+=2) {
    my ($string, $expect) = ($tests[$i], $tests[$i+1]);

    my $mailbox = Email::MIME::RFC2047::AddressList->parse($string);
    is_deeply($mailbox, $expect, "parse $string");
}

