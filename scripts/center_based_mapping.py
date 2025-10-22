def get_signal_vector(chrom, start, end, chip_bed):
    region = pybedtools.BedTool([pybedtools.create_interval_from_list([chrom, str(start), str(end)])])
    signal = chip_bed.intersect(region, wa=True)

    signal_vector = [0.0] * (end - start)
    for interval in signal:
        score = float(interval.score)
        center = (interval.start + interval.end) // 2
        if start <= center < end:
            signal_vector[center - start] += score
    return signal_vector
