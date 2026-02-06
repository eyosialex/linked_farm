$files = @(
    # Chat module
    "lib\Chat\widgets\message_bubble.dart",
    "lib\Chat\widgets\media_preview.dart",
    "lib\Chat\group_info_page.dart",
    "lib\Chat\group_chat_page.dart",
    "lib\Chat\create_group_screen.dart",
    "lib\Chat\comments_page.dart",
    "lib\Chat\chat_screen.dart",
    "lib\Chat\chat_list.dart",
    # Farmers View
    "lib\Farmers View\Position_Sell_Item.dart",
    "lib\Farmers View\My_Products.dart",
    "lib\Farmers View\Market_Prices.dart",
    "lib\Farmers View\FireStore_Config.dart",
    "lib\Farmers View\Farmers_Home.dart",
    "lib\Farmers View\Enter_Sell_Item.dart",
    "lib\Farmers View\advice_feed.dart"
)

$count = 0
foreach ($file in $files) {
    $fullPath = Join-Path "c:\my projects\all-in-one-agricaltural-app" $file
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        if ($content -match 'package:echat/') {
            $content = $content -replace 'package:echat/', 'package:linkedfarm/'
            Set-Content -Path $fullPath -Value $content -NoNewline
            $count++
            Write-Host "Fixed: $file"
        }
    }
}

Write-Host "`nTotal files updated: $count"
