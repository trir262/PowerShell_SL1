Function Out-WebError {
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Net.WebException]
        $WebError
    )
    Process {
        switch ($WebError.Status) {
            ([System.Net.WebExceptionStatus]::ProtocolError) {
            Write-Verbose "Web exception $($WebError.Response) occurred during the post: $($WebError.Response.Headers['X-EM7-status-message'])"
            switch ($WebError.Response.StatusCode) {
                    ([System.Net.HttpStatusCode]::Unauthorized) { $_.Exception.Response }
                    ([System.Net.HttpStatusCode]::NotFound) { $_.Exception.Response }
                    ([system.net.httpstatuscode]::Forbidden) { $_.Exception.Response }
                    ([System.Net.HttpStatusCode]::BadRequest) { throw $WebError }
                    ([System.Net.HttpStatusCode]::NotImplemented) { $_.Exception.Response }
                    default { $_ }
                }
            }
            default {throw "you did do something wrong: $($WebError.Status)"}
        }
    }
}