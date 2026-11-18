using StagedRelease.Sample.Extensions;

var expected = Environment.GetEnvironmentVariable("RELEASE_VERSION");
var actual = ReleaseInfoExtensions.Describe();
Console.WriteLine(actual);

if (actual != $"StagedRelease.Sample {expected}")
{
    Console.Error.WriteLine($"Expected version {expected}.");
    return 1;
}

return 0;
