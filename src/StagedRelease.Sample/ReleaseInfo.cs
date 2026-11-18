using System.Reflection;

namespace StagedRelease.Sample;

public static class ReleaseInfo
{
    public static string Version =>
        typeof(ReleaseInfo).Assembly
            .GetCustomAttribute<AssemblyInformationalVersionAttribute>()?
            .InformationalVersion
            .Split('+')[0]
        ?? "unknown";
}
