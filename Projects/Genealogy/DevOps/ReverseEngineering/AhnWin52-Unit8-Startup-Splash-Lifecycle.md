# Unit8 startup form lifecycle

## Static evidence

The retained `Projects_AhnenWin\Unit8.pas` declares `TForm8` with labels,
images, and `Timer1`, but contains no methods. Its matching
`Source\AhnWin52\Unit8.dfm` sets `Timer1.Interval = 5000` and has no
`OnTimer` assignment. No timer behavior or automatic close can therefore be
reconstructed from these files.

The retained `FPC\AHNWIN52.dpr` startup listing shows this order:

1. Initialize `Application`.
2. Create the `TForm8` instance.
3. Show the instance and call its inherited `Update`.
4. Create the main `TForm1`.

Later in the retained `Projects_AhnenWin\Unit1.pas` `TForm1.FormCreate`
listing (`005D62FA`), the global `TForm8` is explicitly closed after the
startup list-population work, immediately before subsequent configuration
file handling. This establishes a startup-owned close route, but does not
prove the form's intended visual content, ownership/freeing policy, or what
the unbound timer was intended to do.

## Current reconstruction boundary

The current FPC main project uses `Forms\frm_Splash.pas`, a distinct splash
form whose LFM binds its timer to `Timer1OnTimer`. It does not include the
legacy `Unit8` form. The legacy startup sequence cannot be restored by
substituting the current splash handler: they have different units/resources
and no source evidence equating their behavior.

Do not invoke the historical `TForm1.FormCreate` to test this sequence. Its
startup path includes database/table initialization and file configuration
access. No code changes or runtime tests were warranted by this evidence-only
slice.

## Next step

Continue screening only complete pure routines with explicit arguments and
outputs in retained listings. If none is available, keep Unit4/Unit8
resource-only and listing-only behavior documented rather than recreating
startup UI or provider/file paths.
