use utf8;

use Test::More tests => 4 + 11 * 2;

BEGIN {
    use_ok('Email::MIME::RFC2047::Encoder');
    use_ok('Email::MIME::RFC2047::Decoder');
};

my $encoder = Email::MIME::RFC2047::Encoder->new();
ok(defined($encoder), 'new');

my $decoder = Email::MIME::RFC2047::Decoder->new();
ok(defined($decoder), 'new');

my @tests = (
    # white space stripping
    " \t\r\nte-xt\n\r \t", 'te-xt',
    # quoted strings
    'te-xt te;xt', '"te-xt te;xt"',
    'text(text) text, text.', '"text(text) text, text."',
    'text"text\ntext\n"', '"text\"text\\\\ntext\\\\n\""',
    # encoded words
    'Anton  :Berta Cäsar',  '"Anton :Berta" =?utf-8?Q?C=c3=a4sar?=',
    ':Anton Cäsar  Berta',  '":Anton" =?utf-8?Q?C=c3=a4sar?= Berta',
    'Cäsar  Anton  :Berta', '=?utf-8?Q?C=c3=a4sar?= "Anton :Berta"',
    # encoded word splitting
    'ö ö ö ööööööö',  '=?utf-8?Q?=c3=b6_=c3=b6_=c3=b6_=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6?=',
    'ö ö ö ö öööööö', '=?utf-8?Q?=c3=b6_=c3=b6_=c3=b6_=c3=b6_=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6?= =?utf-8?Q?=c3=b6?=',
    # space at boundaries
    'ö ö öööööööö ö',  '=?utf-8?Q?=c3=b6_=c3=b6_=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6_?= =?utf-8?Q?=c3=b6?=',
    'ö ö ö ööööööö ö', '=?utf-8?Q?=c3=b6_=c3=b6_=c3=b6_=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6=c3=b6?= =?utf-8?Q?_=c3=b6?=',
);

for(my $i=0; $i<@tests; $i+=2) {
    my ($string, $expect) = ($tests[$i], $tests[$i+1]);

    my $phrase = $encoder->encode_phrase($string);
    ok(
        $phrase eq $expect,
        "encode_phrase $string, got $phrase, expected $expect"
    );

    my $decoded = $decoder->decode_phrase($phrase);
    $string =~ s/[ \t\r\n]+/ /g;
    $string =~ s/^[ \t\r\n]+//;
    $string =~ s/[ \t\r\n]+\z//;
    ok(
        $decoded eq $string,
        "decode_phrase $phrase, got $decoded, expected $string"
    );
}

