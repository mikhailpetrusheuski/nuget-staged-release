namespace StagedRelease.Sample.Extensions;

public static class ReleaseInfoExtensions
{
    public static string Describe() => $"StagedRelease.Sample {ReleaseInfo.Version}";
}
