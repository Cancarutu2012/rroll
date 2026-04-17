Add-Type -AssemblyName PresentationFramework

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class CursorUtil {
    [DllImport("user32.dll")]
    public static extern int ShowCursor(bool bShow);
}
"@

[CursorUtil]::ShowCursor($false)

# Detect system language
$lang = [System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName

# Simple translation map
$text = switch ($lang) {
    "hu" { "Egy pillanat" }
    "de" { "Bitte warten" }
    "fr" { "Veuillez patienter" }
    "es" { "Espere un momento" }
    "it" { "Attendere un momento" }
    default { "Wait a moment" }
}

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None"
        WindowState="Maximized"
        Background="Black"
        Topmost="True"
        ShowInTaskbar="False">

    <Grid>
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">

            <Canvas Width="80" Height="80" Margin="0,0,0,30">
                <Ellipse Width="80" Height="80"
                         Stroke="White"
                         StrokeThickness="6"
                         StrokeDashArray="1 3">
                    <Ellipse.RenderTransform>
                        <RotateTransform CenterX="40" CenterY="40"/>
                    </Ellipse.RenderTransform>

                    <Ellipse.Triggers>
                        <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                            <BeginStoryboard>
                                <Storyboard RepeatBehavior="Forever">
                                    <DoubleAnimation Storyboard.TargetProperty="(Ellipse.RenderTransform).(RotateTransform.Angle)"
                                                     From="0" To="360"
                                                     Duration="0:0:1"/>
                                </Storyboard>
                            </BeginStoryboard>
                        </EventTrigger>
                    </Ellipse.Triggers>
                </Ellipse>
            </Canvas>

            <TextBlock Name="txt"
                       Foreground="White"
                       FontSize="28"
                       HorizontalAlignment="Center"/>

        </StackPanel>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Inject text after load
$txt = $window.FindName("txt")
$txt.Text = $text

$window.Add_Closed({
    [CursorUtil]::ShowCursor($true) | Out-Null
})

$window.ShowDialog()