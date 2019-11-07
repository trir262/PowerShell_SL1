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
            Write-Verbose "Web exception ""$($WebError.Response.Statusdescription)"" occurred during the post: $($WebError.Response.Headers['X-EM7-status-message'])"
            switch ([System.Net.HttpStatusCode]($WebError.Response.StatusCode)) {
                    ([System.Net.HttpStatusCode]::Unauthorized) { $WebError.Response }
                    ([System.Net.HttpStatusCode]::NotFound) { $WebError.Response }
                    ([system.net.httpstatuscode]::Forbidden) { $WebError.Response }
                    ([System.Net.HttpStatusCode]::BadRequest) { throw $WebError }
                    ([System.Net.HttpStatusCode]::NotImplemented) { $WebError.Response }
                    default { $_ }
                }
            }
            default {throw "The internet messed with your mind, we got an $($WebError.Status) Error"}
        }
    }
}